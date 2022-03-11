import Foundation
import secp256k1

public protocol PublicMasterKeyDerivating {
    func publicKey(
        privateKey: ExtendedKeyable,
        pointFormat: ECPointFormat
    ) throws -> ExtendedKeyable
}

public struct PublicMasterKeyDerivator {
    private static let privateKeyLength = 32
    private static let keyPrefix = UInt8(0)

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
                data: privateKeyData(privateKey.key),
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

// MARK: - Helpers
fileprivate extension PublicMasterKeyDerivator {
    func privateKeyData(_ data: Data) -> Data {
        if data.count != Self.privateKeyLength {
            return Self.keyPrefix.bytes + data
        } else {
            return data
        }
    }
}
