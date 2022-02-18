public struct BitcoinVersionContainer {
    public let version: UInt32

    public init(network: Network, keyAccessControl: KeyAccessControl) {
        switch (network, keyAccessControl) {
        case (.mainnet, .`private`):
            version = 0x0488ADE4
        case (.mainnet, .`public`):
            version = 0x0488B21E
        case (.testnet, .`private`):
            version = 0x04358394
        case (.testnet, .`public`):
            version = 0x043587CF
        }
    }
}
