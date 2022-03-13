extension KeyTestVector {
    struct DerivatedKey: Decodable {
        let depth: UInt8
        let index: UInt32
        let isIndexHardened: Bool
        let base58CheckEncodedPrivateKey: String
        let base58CheckEncodedPublicKey: String
    }
}
