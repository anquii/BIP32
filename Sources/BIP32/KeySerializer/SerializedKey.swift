import Foundation
import CryptoSwift
import BigInt

public protocol SerializedKeyable {
    var data: Data { get }
    var version: UInt32 { get }
    var depth: UInt8 { get }
    var parentKeyFingerprint: UInt32 { get }
    var index: UInt32 { get }
    var chainCode: Data { get }
    var key: Data { get }
}

public struct SerializedKey: SerializedKeyable {
    private static let capacity = 78
    private static let keyLength = 33

    public let data: Data
    public let version: UInt32
    public let depth: UInt8
    public let parentKeyFingerprint: UInt32
    public let index: UInt32
    public let chainCode: Data
    public let key: Data

    init(data: Data, accessControl: KeyAccessControl) throws {
        guard
            data.count == Self.capacity,
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
        chainCode = data[ByteRange.chainCode]
        key = data[ByteRange.key]
        try validate(accessControl: accessControl)
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

    func validate(accessControl: KeyAccessControl) throws {
        let hasNonZeroParentKeyFingerprintAtZeroDepth = depth == UInt8(0) && parentKeyFingerprint != UInt32(0)
        let hasNonZeroIndexAtZeroDepth = depth == UInt8(0) && index != UInt32(0)
        let hasInvalidKeyLength = key.count != Self.keyLength

        var invalidationRules = [
            hasNonZeroParentKeyFingerprintAtZeroDepth,
            hasNonZeroIndexAtZeroDepth,
            hasInvalidKeyLength
        ]

        switch accessControl {
        case .`private`:
            let bigIntegerKey = BigUInt(key)
            let isPrivateKeyInValidRange = !bigIntegerKey.isZero && bigIntegerKey < .secp256k1CurveOrder
            invalidationRules.append(!isPrivateKeyInValidRange)
        case .`public`:
            break
        }

        guard !invalidationRules.contains(true) else {
            throw KeyError.invalidKey
        }
    }
}
