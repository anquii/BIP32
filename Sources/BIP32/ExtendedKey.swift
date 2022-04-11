import Foundation

public protocol ExtendedKeyable {
    var key: Data { get }
    var chainCode: Data { get }
}

public struct ExtendedKey: ExtendedKeyable {
    public let key: Data
    public let chainCode: Data
}

// MARK: - ExtendedKey+SerializedKeyable
public extension ExtendedKey {
    init(serializedKey: SerializedKeyable, accessControl: KeyAccessControl) {
        let key = accessControl == .`private`
            ? serializedKey.key.dropFirst()
            : serializedKey.key
        self = .init(key: key, chainCode: serializedKey.chainCode)
    }
}
