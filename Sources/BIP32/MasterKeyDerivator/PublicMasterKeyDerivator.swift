import Foundation
import secp256k1

public protocol PublicMasterKeyDerivating {
    func publicKey(privateKey: ExtendedKeyable) throws -> ExtendedKeyable
}

public struct PublicMasterKeyDerivator {
    public init() {}
}

// MARK: - PublicMasterKeyDerivating
extension PublicMasterKeyDerivator: PublicMasterKeyDerivating {
    public func publicKey(privateKey: ExtendedKeyable) throws -> ExtendedKeyable {
        do {
            let publicKey = try secp256k1.serializedPoint(data: privateKey.key)
            return ExtendedKey(key: publicKey, chainCode: privateKey.chainCode)
        } catch {
            throw KeyDerivatorError.invalidKey
        }
    }
}
