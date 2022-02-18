import Foundation
import CryptoSwift

public protocol SerializedKeyable {
    var data: Data { get }
    var version: UInt32 { get }
    var depth: UInt8 { get }
    var fingerprint: UInt32 { get }
    var index: UInt32 { get }
    var chainCode: Data { get }
    var key: Data { get }
}

public struct SerializedKey: SerializedKeyable {
    private static let sizeValidationRange = 77...78
    static let capacity = 78

    public let data: Data
    public let version: UInt32
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let chainCode: Data
    public let key: Data

    public init(data: Data) throws {
        guard
            Self.sizeValidationRange.contains(data.count),
            let version = UInt32(data: data[ByteRange.version]),
            let fingerprint = UInt32(data: data[ByteRange.fingerprint]),
            let index = UInt32(data: data[ByteRange.index])
        else {
            throw KeyError.invalidKey
        }
        self.data = data
        self.version = version
        self.fingerprint = fingerprint
        self.index = index
        depth = data[ByteRange.depth]
        chainCode = data[ByteRange.chainCode]
        key = data[ByteRange.key]
    }
}

// MARK: - Helpers
fileprivate extension SerializedKey {
    struct ByteRange {
        static let version = ...3
        static let depth = 4
        static let fingerprint = 5...8
        static let index = 9...12
        static let chainCode = 13...44
        static let key = 45...

        private init() {}
    }
}

// MARK: - UInt32+Data
fileprivate extension UInt32 {
    init?(data: Data) {
        guard let value = Self(data.toHexString(), radix: 16) else {
            return nil
        }
        self = value
    }
}
