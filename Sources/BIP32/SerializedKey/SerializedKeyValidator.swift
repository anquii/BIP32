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
            invalidationRules.append(!isPublicKeyPrefixValid)
        }

        guard !invalidationRules.contains(true) else {
            throw KeyError.invalidKey
        }
    }
}
