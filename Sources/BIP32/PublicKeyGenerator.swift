import secp256k1

public protocol PublicKeyGenerating {
    func publicKey(
        serializedKey: SerializedKeyable,
        format: PublicKeyFormat
    ) -> ExtendedKeyable
}

public struct PublicKeyGenerator {
    public init() {}
}

// MARK: - PublicKeyGenerating
extension PublicKeyGenerator: PublicKeyGenerating {
    public func publicKey(
        serializedKey: SerializedKeyable,
        format: PublicKeyFormat
    ) -> ExtendedKeyable {
        let key = secp256k1.Signing.PublicKey(
            rawRepresentation: serializedKey.key,
            format: .compressed
        ).rawRepresentation

        return ExtendedKey(
            key: key,
            chainCode: serializedKey.chainCode
        )
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
