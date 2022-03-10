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
            let bytes = parentPublicKey.key.bytes + index.bytes
            let hmacSHA512Bytes = try hmacSHA512.authenticate(bytes)
            let key = Data(hmacSHA512Bytes[HMACSHA512ByteRange.left])
            let chainCode = Data(hmacSHA512Bytes[HMACSHA512ByteRange.right])

            guard
                BigUInt(key) < .secp256k1CurveOrder,
                let context = secp256k1_context_create(secp256k1.Context.none.rawValue)
            else {
                throw KeyError.invalidKey
            }

            var publicKey = secp256k1_pubkey()
            let publicKeyFormat = secp256k1.Format(pointFormat)
            var publicKeyLength = publicKeyFormat.length
            var publicKeyBytes = [UInt8](repeating: 0, count: publicKeyLength)
            var randomBytes = [UInt8](repeating: 0, count: 32)

            guard
                SecRandomCopyBytes(
                    kSecRandomDefault,
                    randomBytes.count,
                    &randomBytes
                ) == errSecSuccess,
                secp256k1_context_randomize(
                    context,
                    randomBytes
                ) == 1,
                secp256k1_ec_pubkey_parse(
                    context, &publicKey,
                    parentPublicKey.key.bytes,
                    parentPublicKey.key.count
                ) == 1,
                secp256k1_ec_pubkey_tweak_add(
                    context,
                    &publicKey,
                    key.bytes
                ) == 1,
                secp256k1_ec_pubkey_serialize(
                    context,
                    &publicKeyBytes,
                    &publicKeyLength,
                    &publicKey,
                    publicKeyFormat.rawValue
                ) == 1
            else {
                throw KeyError.invalidKey
            }
            secp256k1_context_destroy(context)

            return ExtendedKey(
                key: Data(publicKeyBytes),
                chainCode: chainCode
            )
        } catch {
            throw KeyError.invalidKey
        }
    }
}
