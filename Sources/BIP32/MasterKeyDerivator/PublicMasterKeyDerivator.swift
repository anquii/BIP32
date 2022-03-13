import Foundation
import secp256k1

public protocol PublicMasterKeyDerivating {
    func publicKey(
        privateKey: ExtendedKeyable,
        pointFormat: ECPointFormat
    ) throws -> ExtendedKeyable
}

public struct PublicMasterKeyDerivator {
    public init() {}
}

// MARK: - PublicMasterKeyDerivating
extension PublicMasterKeyDerivator: PublicMasterKeyDerivating {
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
