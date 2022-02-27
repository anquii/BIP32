public protocol KeyIndexHardening {
    func hardenedIndex(normalIndex: UInt32) throws -> UInt32
}

public struct KeyIndexHardener {
    public init() {}
}

// MARK: - KeyIndexHardening
extension KeyIndexHardener: KeyIndexHardening {
    public func hardenedIndex(normalIndex: UInt32) throws -> UInt32 {
        try validateIndex(normalIndex, isHardened: false)
        let hardenedIndex = normalIndex + KeyIndexRange.hardened.lowerBound
        try validateIndex(hardenedIndex, isHardened: true)
        return hardenedIndex
    }
}

// MARK: - Helpers
fileprivate extension KeyIndexHardener {
    func validateIndex(_ index: UInt32, isHardened: Bool) throws {
        let indexRange = isHardened
            ? KeyIndexRange.hardened
            : KeyIndexRange.normal

        guard indexRange.contains(index) else {
            throw KeyIndexError.invalidIndex
        }
    }
}
