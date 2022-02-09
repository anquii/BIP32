public protocol ChildKeyIndexValidating {
    func validateIndex(_ index: UInt32, isHardened: Bool) throws
}

public struct ChildKeyIndexValidator {
    public init() {}
}

// MARK: - ChildKeyIndexValidating
extension ChildKeyIndexValidator: ChildKeyIndexValidating {
    public func validateIndex(_ index: UInt32, isHardened: Bool) throws {
        let rules = [
            !isHardened && ChildKeyDerivationRange.normal.contains(index),
            isHardened && ChildKeyDerivationRange.hardened.contains(index)
        ]

        if !rules.contains(true) {
            throw ChildKeyIndexError.invalidIndex
        }
    }
}
