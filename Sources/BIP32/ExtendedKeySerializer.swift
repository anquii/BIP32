import Foundation

public protocol ExtendedKeySerializing {
    func serializedExtendedKey(_ extendedKey: ExtendedKeyable) throws -> Data
}

public struct ExtendedKeySerializer {
    public init() {}
}

// MARK: - ExtendedKeySerializing
extension ExtendedKeySerializer: ExtendedKeySerializing {
    public func serializedExtendedKey(_ extendedKey: ExtendedKeyable) throws -> Data {
        .init()
    }
}
