public protocol ChildKeyDerivating {
    func childKey(index: UInt32) throws -> ExtendedKeyable
}

public struct ChildKeyDerivator {
    private let parentKey: ExtendedKeyable

    public init(parentKey: ExtendedKeyable) {
        self.parentKey = parentKey
    }
}

// MARK: - ChildKeyDerivating
extension ChildKeyDerivator: ChildKeyDerivating {
    public func childKey(index: UInt32) throws -> ExtendedKeyable {
        fatalError()
    }
}
