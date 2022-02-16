import Foundation

public protocol KeySerializing {
    func serializedKey(
        extendedKey: ExtendedKeyable,
        version: UInt32,
        depth: UInt8,
        fingerprint: UInt32,
        index: UInt32
    ) throws -> SerializedKeyable
}

public struct KeySerializer {
    private static let capacity = 78
    private static let sizeValidationRange = 77...78

    public init() {}
}

// MARK: - KeySerializing
extension KeySerializer: KeySerializing {
    public func serializedKey(
        extendedKey: ExtendedKeyable,
        version: UInt32,
        depth: UInt8,
        fingerprint: UInt32,
        index: UInt32
    ) throws -> SerializedKeyable {
        var data = Data(capacity: Self.capacity)

        data += version.bytes
        data += depth.bytes
        data += fingerprint.bytes
        data += index.bytes
        data += extendedKey.chainCode
        data += extendedKey.key

        guard Self.sizeValidationRange.contains(data.count) else {
            throw KeyError.invalidKey
        }

        return SerializedKey(data: data)
    }
}

// MARK: - FixedWidthInteger+Bytes
fileprivate extension FixedWidthInteger {
    var bytes: [UInt8] {
        withUnsafeBytes(of: byteSwapped, Array.init)
    }
}
