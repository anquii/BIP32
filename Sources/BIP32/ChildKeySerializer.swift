import Foundation

public protocol ChildKeySerializing {
    func serializedChildKey(
        extendedKey: ExtendedKeyable,
        version: UInt32,
        depth: UInt8,
        fingerprint: UInt32,
        index: UInt32
    ) throws -> SerializedKeyable
}

public struct ChildKeySerializer {
    public init() {}
}

// MARK: - ChildKeySerializing
extension ChildKeySerializer: ChildKeySerializing {
    public func serializedChildKey(
        extendedKey: ExtendedKeyable,
        version: UInt32,
        depth: UInt8,
        fingerprint: UInt32,
        index: UInt32
    ) throws -> SerializedKeyable {
        var data = Data(capacity: SerializedKeySize.capacity)

        data += version.bytes
        data += depth.bytes
        data += fingerprint.bytes
        data += index.bytes
        data += extendedKey.chainCode
        data += extendedKey.key

        return try SerializedKey(data: data)
    }
}
