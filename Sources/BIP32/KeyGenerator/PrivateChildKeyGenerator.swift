import Foundation
import secp256k1
import CryptoSwift

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
            keyBytes = Self.keyPrefix.bytes + privateParentKey.key.bytes
        } else {
            keyBytes = try secp256k1
                .Signing
                .PrivateKey(
                    rawRepresentation: privateParentKey.key,
                    format: secp256k1.Format(pointFormat)
                )
                .publicKey
                .rawRepresentation
                .bytes
        }

        let hmacSHA512 = HMAC(
            key: privateParentKey.chainCode.bytes,
            variant: .sha2(.sha512)
        )
        do {
            let bytes = keyBytes + index.bytes
            let hmacSHA512Bytes = try hmacSHA512.authenticate(bytes)
            let key = hmacSHA512Bytes[HMACSHA512ByteRange.left]
            let chainCode = hmacSHA512Bytes[HMACSHA512ByteRange.right]

            return ExtendedKey(
                key: Data(key),
                chainCode: Data(chainCode)
            )
        } catch {
            throw KeyError.invalidKey
        }
    }
}
