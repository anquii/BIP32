public protocol ChildKeyIndexContaining {
    var index: UInt32 { get }
}

public struct ChildKeyIndexContainer: ChildKeyIndexContaining {
    public let index: UInt32

    public init(
        index: UInt32,
        indexValidator: ChildKeyIndexValidating = ChildKeyIndexValidator(),
        shouldHarden: Bool
    ) throws {
        self.index = shouldHarden ? ChildKeyDerivationRange.hardened.lowerBound + index : index
        try indexValidator.validateIndex(self.index, isHardened: shouldHarden)
    }
}
