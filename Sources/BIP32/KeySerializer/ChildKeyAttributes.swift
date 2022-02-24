public struct ChildKeyAttributes: KeyAttributes {
    public var accessControl: KeyAccessControl
    public var version: UInt32
    public var depth: UInt8
    public var parentKeyFingerprint: UInt32
    public var index: UInt32

    public init(
        accessControl: KeyAccessControl,
        version: UInt32,
        depth: UInt8,
        parentKeyFingerprint: UInt32,
        index: UInt32
    ) {
        self.accessControl = accessControl
        self.version = version
        self.depth = depth
        self.parentKeyFingerprint = parentKeyFingerprint
        self.index = index
    }
}
