import Foundation

public protocol KeySerializing {
    func serializedKey(
        extendedKey: ExtendedKeyable,
        attributes: KeyAttributes
    ) throws -> SerializedKeyable
}

public struct KeySerializer {
    private static let capacity = 78
    private static let keyPrefix = UInt8(0)

    public init() {}
}

// MARK: - KeySerializing
extension KeySerializer: KeySerializing {
    public func serializedKey(
        extendedKey: ExtendedKeyable,
        attributes: KeyAttributes
    ) throws -> SerializedKeyable {
        var data = Data(capacity: Self.capacity)

        let isPrivateMasterKey = attributes.depth == 0
            && attributes.accessControl == .private
        let isHardenedPrivateChildKey = attributes.depth != 0
            && attributes.accessControl == .private
            && KeyIndexRange.hardened.contains(attributes.index)

        data += attributes.version.bytes
        data += attributes.depth.bytes
        data += attributes.parentKeyFingerprint.bytes
        data += attributes.index.bytes
        data += extendedKey.chainCode
        if isPrivateMasterKey || isHardenedPrivateChildKey {
            data += Self.keyPrefix.bytes
        }
        data += extendedKey.key

        return try SerializedKey(data: data)
    }
}
