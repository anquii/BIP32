import secp256k1

public protocol PublicKeyGenerating {
    func publicKey(
        extendedPrivateKey: ExtendedKeyable,
        format: PublicKeyFormat
    ) throws -> ExtendedKeyable
}

public struct PublicKeyGenerator {
    public init() {}
}

// MARK: - PublicKeyGenerating
extension PublicKeyGenerator: PublicKeyGenerating {
    public func publicKey(
        extendedPrivateKey: ExtendedKeyable,
        format: PublicKeyFormat
    ) throws -> ExtendedKeyable {
        do {
            let privateKey = try secp256k1.Signing.PrivateKey(
                rawRepresentation: extendedPrivateKey.key,
                format: secp256k1.Format(format)
            )
            let publicKey = privateKey
                .publicKey
                .rawRepresentation

            return ExtendedKey(
                key: publicKey,
                chainCode: extendedPrivateKey.chainCode
            )
        } catch {
            throw KeyError.invalidKey
        }
    }
}

// MARK: - secp256k1.Format+PublicKeyFormat
fileprivate extension secp256k1.Format {
    init(_ format: PublicKeyFormat) {
        switch format {
        case .compressed:
            self = .compressed
        case .uncompressed:
            self = .uncompressed
        }
    }
}
