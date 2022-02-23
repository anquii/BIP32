public protocol KeyIndexValidating {
    func validateIndex(_ index: UInt32, isHardened: Bool) throws
}

public struct KeyIndexValidator {
    public init() {}
}

// MARK: - KeyIndexValidating
extension KeyIndexValidator: KeyIndexValidating {
    public func validateIndex(_ index: UInt32, isHardened: Bool) throws {
        let rules = [
            !isHardened && KeyIndexRange.normal.contains(index),
            isHardened && KeyIndexRange.hardened.contains(index)
        ]

        if !rules.contains(true) {
            throw KeyIndexError.invalidIndex
        }
    }
}
