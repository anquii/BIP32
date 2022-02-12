public protocol KeyIndexTransforming {
    func index(_ index: UInt32, shouldHarden: Bool) throws -> UInt32
}

public struct KeyIndexTransformer {
    public init() {}
}

// MARK: - KeyIndexTransforming
extension KeyIndexTransformer: KeyIndexTransforming {
    public func index(_ index: UInt32, shouldHarden: Bool) throws -> UInt32 {
        guard shouldHarden else {
            return index
        }

        let maxDistance = index.distance(to: KeyDerivationRange.hardened.upperBound)
        let hardenedBase = KeyDerivationRange.hardened.lowerBound

        if maxDistance >= hardenedBase {
            return index + KeyDerivationRange.hardened.lowerBound
        } else {
            throw KeyIndexError.memorySpaceExceeded
        }
    }
}
