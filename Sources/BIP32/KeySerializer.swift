import Foundation

public protocol KeySerializing {
    func serializedKey(_ key: ExtendedKeyable) throws -> Data
}

public struct KeySerializer {
    public init() {}
}

// MARK: - KeySerializing
extension KeySerializer: KeySerializing {
    public func serializedKey(_ key: ExtendedKeyable) throws -> Data {
        .init()
    }
}
