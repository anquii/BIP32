public protocol ChildKeyIndexContaining {
    var index: UInt32 { get }
}

public struct ChildKeyIndexContainer: ChildKeyIndexContaining {
    public let index: UInt32

    public init(
        index: UInt32,
        indexTransformer: ChildKeyIndexTransforming = ChildKeyIndexTransformer(),
        indexValidator: ChildKeyIndexValidating = ChildKeyIndexValidator(),
        shouldHarden: Bool
    ) throws {
        let transformedIndex = try indexTransformer.index(index, shouldHarden: shouldHarden)
        try indexValidator.validateIndex(transformedIndex, isHardened: shouldHarden)
        self.index = transformedIndex
    }
}
