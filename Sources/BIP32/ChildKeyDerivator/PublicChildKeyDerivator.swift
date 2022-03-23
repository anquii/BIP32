import Foundation
import secp256k1
import CryptoSwift
import BigInt

public protocol PublicChildKeyDerivating {
    func publicKey(privateKey: ExtendedKeyable) throws -> ExtendedKeyable
    func publicKey(publicParentKey: ExtendedKeyable, index: UInt32) throws -> ExtendedKeyable
}

public struct PublicChildKeyDerivator {
    public init() {}
}

// MARK: - PublicChildKeyDerivating
extension PublicChildKeyDerivator: PublicChildKeyDerivating {
    public func publicKey(privateKey: ExtendedKeyable) throws -> ExtendedKeyable {
        do {
            let publicKey = try secp256k1.serializedPoint(data: privateKey.key)
            return ExtendedKey(key: publicKey, chainCode: privateKey.chainCode)
        } catch {
            throw KeyError.invalidKey
        }
    }

    public func publicKey(publicParentKey: ExtendedKeyable, index: UInt32) throws -> ExtendedKeyable {
        guard KeyIndexRange.normal.contains(index) else {
            throw KeyError.invalidKey
        }

        let hmacSHA512 = HMAC(key: publicParentKey.chainCode.bytes, variant: .sha2(.sha512))
        do {
            let bytes = publicParentKey.key.bytes + index.bytes
            let hmacSHA512Bytes = try hmacSHA512.authenticate(bytes)
            let key = Data(hmacSHA512Bytes[HMACSHA512ByteRange.left])
            let chainCode = Data(hmacSHA512Bytes[HMACSHA512ByteRange.right])

            guard
                BigUInt(key) < .secp256k1CurveOrder,
                let context = secp256k1_context_create(secp256k1.Context.none.rawValue)
            else {
                throw KeyError.invalidKey
            }
            var parsedPublicKey = secp256k1_pubkey()
            let publicKeyFormat = secp256k1.Format.compressed
            var publicKeyLength = publicKeyFormat.length
            var publicKeyBytes = [UInt8](repeating: 0, count: publicKeyLength)
            var randomBytes = [UInt8](repeating: 0, count: 32)

            guard
                SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes) == errSecSuccess,
                secp256k1_context_randomize(context, randomBytes) == 1,
                secp256k1_ec_pubkey_parse(context, &parsedPublicKey, publicParentKey.key.bytes, publicParentKey.key.count) == 1,
                secp256k1_ec_pubkey_tweak_add(context, &parsedPublicKey, key.bytes) == 1,
                secp256k1_ec_pubkey_serialize(context, &publicKeyBytes, &publicKeyLength, &parsedPublicKey, publicKeyFormat.rawValue) == 1
            else {
                throw KeyError.invalidKey
            }
            secp256k1_context_destroy(context)

            return ExtendedKey(key: Data(publicKeyBytes), chainCode: chainCode)
        } catch {
            throw KeyError.invalidKey
        }
    }
}
