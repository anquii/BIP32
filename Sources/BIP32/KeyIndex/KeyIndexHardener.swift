public protocol KeyIndexHardening {
    func hardenedIndex(normalIndex: UInt32) throws -> UInt32
}

public struct KeyIndexHardener {
    public init() {}
}

// MARK: - KeyIndexHardening
extension KeyIndexHardener: KeyIndexHardening {
    public func hardenedIndex(normalIndex: UInt32) throws -> UInt32 {
        let maxDistance = normalIndex.distance(to: KeyIndexRange.hardened.upperBound)
        let hardenedBase = KeyIndexRange.hardened.lowerBound

        if maxDistance >= hardenedBase {
            return normalIndex + KeyIndexRange.hardened.lowerBound
        } else {
            throw KeyIndexError.memorySpaceExceeded
        }
    }
}
