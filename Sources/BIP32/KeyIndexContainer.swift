public protocol KeyIndexContaining {
    var index: UInt32 { get }
}

public struct KeyIndexContainer: KeyIndexContaining {
    public let index: UInt32

    public init(
        index: UInt32,
        indexTransformer: KeyIndexTransforming = KeyIndexTransformer(),
        indexValidator: KeyIndexValidating = KeyIndexValidator(),
        shouldHarden: Bool
    ) throws {
        let transformedIndex = try indexTransformer.index(index, shouldHarden: shouldHarden)
        try indexValidator.validateIndex(transformedIndex, isHardened: shouldHarden)
        self.index = transformedIndex
    }
}
