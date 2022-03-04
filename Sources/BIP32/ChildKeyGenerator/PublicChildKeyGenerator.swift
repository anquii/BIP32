import Foundation
import secp256k1
import CryptoSwift
import BigInt

public protocol PublicChildKeyGenerating {
    func publicKey(
        privateChildKey: ExtendedKeyable,
        pointFormat: ECPointFormat
    ) throws -> ExtendedKeyable

    func publicKey(
        parentPublicKey: ExtendedKeyable,
        pointFormat: ECPointFormat,
        index: UInt32
    ) throws -> ExtendedKeyable
}

public struct PublicChildKeyGenerator {
    public init() {}
}

// MARK: - PublicChildKeyGenerating
extension PublicChildKeyGenerator: PublicChildKeyGenerating {
    public func publicKey(
        privateChildKey: ExtendedKeyable,
        pointFormat: ECPointFormat = .compressed
    ) throws -> ExtendedKeyable {
        do {
            let publicKey = try secp256k1.serializedPoint(
                data: privateChildKey.key,
                format: pointFormat
            )
            return ExtendedKey(
                key: publicKey,
                chainCode: privateChildKey.chainCode
            )
        } catch {
            throw KeyError.invalidKey
        }
    }

    public func publicKey(
        parentPublicKey: ExtendedKeyable,
        pointFormat: ECPointFormat = .compressed,
        index: UInt32
    ) throws -> ExtendedKeyable {
        guard KeyIndexRange.normal.contains(index) else {
            throw KeyError.invalidKey
        }

        let hmacSHA512 = HMAC(
            key: parentPublicKey.chainCode.bytes,
            variant: .sha2(.sha512)
        )
        do {
            let publicKey = try secp256k1.serializedPoint(
                data: parentPublicKey.key,
                format: pointFormat
            )
            let bytes = publicKey.bytes + index.bytes
            let hmacSHA512Bytes = try hmacSHA512.authenticate(bytes)
            let key = Data(hmacSHA512Bytes[HMACSHA512ByteRange.left])
            let chainCode = Data(hmacSHA512Bytes[HMACSHA512ByteRange.right])

            let base256Key = BigUInt(key)
            let serializedPoint = try secp256k1.serializedPoint(
                data: base256Key.serialize(),
                format: pointFormat
            )

            let computedChildKey = serializedPoint + parentPublicKey.key
            guard base256Key < .secp256k1CurveOrder else {
                throw KeyError.invalidKey
            }

            return ExtendedKey(
                key: computedChildKey,
                chainCode: chainCode
            )
        } catch {
            throw KeyError.invalidKey
        }
    }
}
