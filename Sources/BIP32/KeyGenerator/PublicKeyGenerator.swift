import secp256k1

public protocol PublicKeyGenerating {
    func publicKey(
        privateKey: ExtendedKeyable,
        format: PublicKeyFormat
    ) throws -> ExtendedKeyable
}

public struct PublicKeyGenerator {
    public init() {}
}

// MARK: - PublicKeyGenerating
extension PublicKeyGenerator: PublicKeyGenerating {
    public func publicKey(
        privateKey: ExtendedKeyable,
        format: PublicKeyFormat
    ) throws -> ExtendedKeyable {
        do {
            let publicKey = try secp256k1
                .Signing
                .PrivateKey(
                    rawRepresentation: privateKey.key,
                    format: secp256k1.Format(format)
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
