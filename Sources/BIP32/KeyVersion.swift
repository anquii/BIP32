@propertyWrapper public struct KeyVersion {
    public let wrappedValue: UInt32

    public init(network: Network, keyAccessControl: KeyAccessControl) {
        switch (network, keyAccessControl) {
        case (.mainnet, .`private`):
            wrappedValue = 0x0488ADE4
        case (.mainnet, .`public`):
            wrappedValue = 0x0488B21E
        case (.testnet, .`private`):
            wrappedValue = 0x04358394
        case (.testnet, .`public`):
            wrappedValue = 0x043587CF
        }
    }
}
