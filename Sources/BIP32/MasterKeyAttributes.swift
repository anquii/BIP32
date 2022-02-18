public struct MasterKeyAttributes: KeyAttributes {
    public var accessControl = KeyAccessControl.private
    public var version: UInt32
    public var depth = UInt8(0)
    public var parentFingerprint = UInt32(0)
    public var index = UInt32(0)

    public init(version: UInt32) {
        self.version = version
    }
}
