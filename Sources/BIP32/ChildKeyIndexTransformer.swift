public protocol ChildKeyIndexTransforming {
    func index(_ index: UInt32, shouldHarden: Bool) throws -> UInt32
}

public struct ChildKeyIndexTransformer {
    public init() {}
}

// MARK: - ChildKeyIndexTransforming
extension ChildKeyIndexTransformer: ChildKeyIndexTransforming {
    public func index(_ index: UInt32, shouldHarden: Bool) throws -> UInt32 {
        guard shouldHarden else {
            return index
        }

        let maxDistance = index.distance(to: ChildKeyDerivationRange.hardened.upperBound)
        let hardenedBase = ChildKeyDerivationRange.hardened.lowerBound

        if maxDistance >= hardenedBase {
            return index + ChildKeyDerivationRange.hardened.lowerBound
        } else {
            throw ChildKeyIndexError.memorySpaceExceeded
        }
    }
}
