import secp256k1

public protocol PublicKeyGenerating {
    func publicKey(
        privateKey: ExtendedKeyable,
        pointFormat: ECPointFormat
    ) throws -> ExtendedKeyable
}

public struct PublicKeyGenerator {
    public init() {}
}

// MARK: - PublicKeyGenerating
extension PublicKeyGenerator: PublicKeyGenerating {
    public func publicKey(
        privateKey: ExtendedKeyable,
        pointFormat: ECPointFormat = .compressed
    ) throws -> ExtendedKeyable {
        do {
            let publicKey = try secp256k1
                .Signing
                .PrivateKey(
                    rawRepresentation: privateKey.key,
                    format: secp256k1.Format(pointFormat)
                )
                .publicKey
                .rawRepresentation

            return ExtendedKey(
                key: publicKey,
                chainCode: privateKey.chainCode
            )
        } catch {
            throw KeyError.invalidKey
        }
    }
}
