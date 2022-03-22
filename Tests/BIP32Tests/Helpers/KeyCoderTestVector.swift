struct KeyCoderTestVector: Decodable {
    let base58CheckEncodedKey: String
    let isPrivate: Bool
}
