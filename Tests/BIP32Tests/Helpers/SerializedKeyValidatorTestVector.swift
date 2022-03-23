struct SerializedKeyValidatorTestVector: Decodable {
    let base58CheckEncodedKey: String
    let isPrivate: Bool
}
