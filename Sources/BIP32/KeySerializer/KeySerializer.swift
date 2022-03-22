import Foundation

public protocol KeySerializing {
    func serializedKey(
        extendedKey: ExtendedKeyable,
        attributes: KeyAttributes
    ) throws -> SerializedKeyable
}

public struct KeySerializer {
    static let serializedKeyCapacity = 78

    public init() {}
}

// MARK: - KeySerializing
extension KeySerializer: KeySerializing {
    public func serializedKey(
        extendedKey: ExtendedKeyable,
        attributes: KeyAttributes
    ) throws -> SerializedKeyable {
        var data = Data(capacity: Self.serializedKeyCapacity)

        data += attributes.version.bytes
        data += attributes.depth.bytes
        data += attributes.parentKeyFingerprint.bytes
        data += attributes.index.bytes
        data += extendedKey.chainCode
        data += extendedKey.key

        return try SerializedKey(data: data, accessControl: attributes.accessControl)
    }
}
