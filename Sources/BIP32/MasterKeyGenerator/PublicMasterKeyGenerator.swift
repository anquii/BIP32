import secp256k1

public protocol PublicMasterKeyGenerating {
    func publicKey(
        privateKey: ExtendedKeyable,
        pointFormat: ECPointFormat
    ) throws -> ExtendedKeyable
}

public struct PublicMasterKeyGenerator {
    public init() {}
}

// MARK: - PublicMasterKeyGenerating
extension PublicMasterKeyGenerator: PublicMasterKeyGenerating {
    public func publicKey(
        privateKey: ExtendedKeyable,
        pointFormat: ECPointFormat = .compressed
    ) throws -> ExtendedKeyable {
        do {
            let publicKey = try secp256k1.serializedPoint(
                data: privateKey.key,
                format: pointFormat
            )
            return ExtendedKey(
                key: publicKey,
                chainCode: privateKey.chainCode
            )
        } catch {
            throw KeyError.invalidKey
        }
    }
}
