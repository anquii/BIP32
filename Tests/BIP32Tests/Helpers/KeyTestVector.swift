struct KeyTestVector: Decodable {
    let hexEncodedSeed: String
    let derivatedKeys: [DerivatedKey]
}
