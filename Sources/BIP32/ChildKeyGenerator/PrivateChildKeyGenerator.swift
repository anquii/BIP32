import Foundation
import secp256k1
import CryptoSwift
import BigInt

public protocol PrivateChildKeyGenerating {
    func privateChildKey(
        privateParentKey: ExtendedKeyable,
        pointFormat: ECPointFormat,
        index: UInt32
    ) throws -> ExtendedKeyable
}

public struct PrivateChildKeyGenerator {
    private static let keyPrefix = UInt8(0)

    public init() {}
}

// MARK: - PrivateChildKeyGenerating
extension PrivateChildKeyGenerator: PrivateChildKeyGenerating {
    public func privateChildKey(
        privateParentKey: ExtendedKeyable,
        pointFormat: ECPointFormat = .compressed,
        index: UInt32
    ) throws -> ExtendedKeyable {
        let keyBytes: [UInt8]

        if KeyIndexRange.hardened.contains(index) {
            keyBytes = Self.keyPrefix.bytes + privateParentKey.key
        } else {
            keyBytes = try secp256k1.serializedPoint(
                data: privateParentKey.key,
                format: pointFormat
            ).bytes
        }

        let hmacSHA512 = HMAC(
            key: privateParentKey.chainCode.bytes,
            variant: .sha2(.sha512)
        )
        do {
            let bytes = keyBytes + index.bytes
            let hmacSHA512Bytes = try hmacSHA512.authenticate(bytes)
            let key = Data(hmacSHA512Bytes[HMACSHA512ByteRange.left])
            let chainCode = Data(hmacSHA512Bytes[HMACSHA512ByteRange.right])

            let base256Key = BigUInt(key)
            let base256ParentKey = BigUInt(privateParentKey.key)
            let computedChildKey = (base256Key + base256ParentKey) % .secp256k1CurveOrder
            guard !computedChildKey.isZero, base256Key < .secp256k1CurveOrder else {
                throw KeyError.invalidKey
            }

            return ExtendedKey(
                key: computedChildKey.serialize(),
                chainCode: chainCode
            )
        } catch {
            throw KeyError.invalidKey
        }
    }
}
