import Foundation
import CryptoSwift

public protocol SerializedKeyable {
    var data: Data { get }
    var version: UInt32 { get }
    var depth: UInt8 { get }
    var parentKeyFingerprint: UInt32 { get }
    var index: UInt32 { get }
    var extendedKey: ExtendedKeyable { get }
}

public struct SerializedKey: SerializedKeyable {
    private static let length = 78

    public let data: Data
    public let version: UInt32
    public let depth: UInt8
    public let parentKeyFingerprint: UInt32
    public let index: UInt32
    public let extendedKey: ExtendedKeyable

    init(data: Data) throws {
        guard
            data.count == Self.length,
            let version = UInt32(data: data[ByteRange.version]),
            let parentKeyFingerprint = UInt32(data: data[ByteRange.parentKeyFingerprint]),
            let index = UInt32(data: data[ByteRange.index])
        else {
            throw KeyError.invalidKey
        }
        self.data = data
        self.version = version
        self.parentKeyFingerprint = parentKeyFingerprint
        self.index = index
        depth = data[ByteRange.depth]
        extendedKey = ExtendedKey(
            key: data[ByteRange.key],
            chainCode: data[ByteRange.chainCode]
        )
    }
}

// MARK: - Helpers
fileprivate extension SerializedKey {
    struct ByteRange {
        static let version = ...3
        static let depth = 4
        static let parentKeyFingerprint = 5...8
        static let index = 9...12
        static let chainCode = 13...44
        static let key = 45...

        private init() {}
    }
}
