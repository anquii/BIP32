import Foundation
import secp256k1
import BigInt

public protocol SerializedKeyValidating {
    func validate(serializedKey: SerializedKeyable, keyAccessControl: KeyAccessControl) throws
}

public struct SerializedKeyValidator {
    private static let keyLength = 33

    public init() {}
}

// MARK: - SerializedKeyValidating
extension SerializedKeyValidator: SerializedKeyValidating {
    public func validate(serializedKey: SerializedKeyable, keyAccessControl: KeyAccessControl) throws {
        let hasNonZeroParentKeyFingerprintAtZeroDepth = serializedKey.depth == UInt8(0) && serializedKey.parentKeyFingerprint != UInt32(0)
        let hasNonZeroIndexAtZeroDepth = serializedKey.depth == UInt8(0) && serializedKey.index != UInt32(0)
        let hasInvalidKeyLength = serializedKey.key.count != Self.keyLength

        var invalidationRules = [
            hasNonZeroParentKeyFingerprintAtZeroDepth,
            hasNonZeroIndexAtZeroDepth,
            hasInvalidKeyLength
        ]

        let firstByte = serializedKey.key.bytes.first!
        switch keyAccessControl {
        case .`private`:
            let bigIntegerKey = BigUInt(serializedKey.key)
            let isPrivateKeyInValidRange = !bigIntegerKey.isZero && bigIntegerKey < .secp256k1CurveOrder
            let isPrivateKeyPrefixValid = firstByte == UInt8(0)
            invalidationRules.append(contentsOf: [!isPrivateKeyInValidRange, !isPrivateKeyPrefixValid])
        case .`public`:
            let isPublicKeyPrefixValid = (2...3).contains(firstByte)
            let hasVerifiedCurvePoint = try hasVerifiedPublicKeyCurvePoint(publicKey: serializedKey.key)
            invalidationRules.append(contentsOf: [!isPublicKeyPrefixValid, !hasVerifiedCurvePoint])
        }

        guard !invalidationRules.contains(true) else {
            throw KeyError.invalidKey
        }
    }
}

// MARK: - Helpers
fileprivate extension SerializedKeyValidator {
    func hasVerifiedPublicKeyCurvePoint(publicKey: Data) throws -> Bool {
        guard let context = secp256k1_context_create(secp256k1.Context.none.rawValue) else {
            throw KeyError.invalidKey
        }
        defer {
            secp256k1_context_destroy(context)
        }
        var parsedPublicKey = secp256k1_pubkey()
        var randomBytes = [UInt8](repeating: 0, count: 32)
        if SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes) == errSecSuccess,
            secp256k1_context_randomize(context, randomBytes) == 1,
            secp256k1_ec_pubkey_parse(context, &parsedPublicKey, publicKey.bytes, publicKey.count) == 1 {
            return true
        } else {
            return false
        }
    }
}
