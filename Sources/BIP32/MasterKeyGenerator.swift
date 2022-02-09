import Foundation

public protocol MasterKeyGenerating {
    func masterKey(seed: Data) throws -> ExtendedKeyable
}

public struct MasterKeyGenerator {
    public init() {}
}

// MARK: - MasterKeyGenerating
extension MasterKeyGenerator: MasterKeyGenerating {
    public func masterKey(seed: Data) throws -> ExtendedKeyable {
        fatalError()
    }
}
