import Foundation

public protocol SerializedKeyable {
    var data: Data { get }
    var version: UInt32 { get }
    var depth: UInt8 { get }
    var fingerprint: UInt32 { get }
    var index: UInt32 { get }
    var chainCode: Data { get }
    var key: Data { get }
}

public struct SerializedKey {
    public var data: Data

    public init(data: Data) {
        self.data = data
    }
}

// MARK: - SerializedKeyable
extension SerializedKey: SerializedKeyable {
    public var version: UInt32 {
        .init(data: data[ByteRange.version])
    }

    public var depth: UInt8 {
        data[ByteRange.depth]
    }

    public var fingerprint: UInt32 {
        .init(data: data[ByteRange.fingerprint])
    }

    public var index: UInt32 {
        .init(data: data[ByteRange.index])
    }

    public var chainCode: Data {
        data[ByteRange.chainCode]
    }

    public var key: Data {
        data[ByteRange.key]
    }
}

// MARK: - Helpers
fileprivate extension SerializedKey {
    struct ByteRange {
        private init() {}

        static let version = ...3
        static let depth = 4
        static let fingerprint = 5...8
        static let index = 9...12
        static let chainCode = 13...44
        static let key = 45...
    }
}

// MARK: - UInt32+Data
fileprivate extension UInt32 {
    init(data: Data) {
        self = data.withUnsafeBytes {
            $0.load(as: UInt32.self)
        }
    }
}
