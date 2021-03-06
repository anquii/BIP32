public protocol KeyAttributes {
    var accessControl: KeyAccessControl { get }
    var version: UInt32 { get }
    var depth: UInt8 { get }
    var parentKeyFingerprint: UInt32 { get }
    var index: UInt32 { get }
}
