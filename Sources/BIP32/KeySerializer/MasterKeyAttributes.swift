public struct MasterKeyAttributes: KeyAttributes {
    public var accessControl: KeyAccessControl
    public var version: UInt32
    public var depth = UInt8(0)
    public var parentKeyFingerprint = UInt32(0)
    public var index = UInt32(0)

    public init(accessControl: KeyAccessControl, version: UInt32) {
        self.accessControl = accessControl
        self.version = version
    }
}
