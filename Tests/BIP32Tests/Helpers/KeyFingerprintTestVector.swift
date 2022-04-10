struct KeyFingerprintTestVector: Decodable {
    let hexEncodedPublicKey: String
    let hexEncodedPublicKeyFingerprint: String
    let hexEncodedPublicKeyHash160: String
}
