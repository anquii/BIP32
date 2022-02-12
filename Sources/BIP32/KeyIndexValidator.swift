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
            !isHardened && KeyDerivationRange.normal.contains(index),
            isHardened && KeyDerivationRange.hardened.contains(index)
        ]

        if !rules.contains(true) {
            throw KeyIndexError.invalidIndex
        }
    }
}
