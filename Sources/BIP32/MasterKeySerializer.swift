import Foundation

public protocol MasterKeySerializing {
    func serializedKey(
        extendedKey: ExtendedKeyable,
        version: UInt32
    ) throws -> SerializedKeyable
}

public struct MasterKeySerializer {
    private static let depth = UInt8(0)
    private static let fingerprint = UInt32(0)
    private static let index = UInt32(0)
    private static let keyPrefix = UInt8(0)

    public init() {}
}

// MARK: - MasterKeySerializing
extension MasterKeySerializer: MasterKeySerializing {
    public func serializedKey(
        extendedKey: ExtendedKeyable,
        version: UInt32
    ) throws -> SerializedKeyable {
        var data = Data(capacity: SerializedKeySize.capacity)

        data += version.bytes
        data += Self.depth.bytes
        data += Self.fingerprint.bytes
        data += Self.index.bytes
        data += extendedKey.chainCode
        data += Self.keyPrefix.bytes
        data += extendedKey.key

        return try SerializedKey(data: data)
    }
}
