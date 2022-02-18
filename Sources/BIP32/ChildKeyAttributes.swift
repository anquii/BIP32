public struct ChildKeyAttributes: KeyAttributes {
    public var accessControl: KeyAccessControl
    public var version: UInt32
    public var depth: UInt8
    public var parentFingerprint: UInt32
    public var index: UInt32

    public init(
        accessControl: KeyAccessControl,
        version: UInt32,
        depth: UInt8,
        parentFingerprint: UInt32,
        index: UInt32
    ) {
        self.accessControl = accessControl
        self.version = version
        self.depth = depth
        self.parentFingerprint = parentFingerprint
        self.index = index
    }
}
