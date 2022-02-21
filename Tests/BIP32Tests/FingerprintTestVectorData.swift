/// https://github.com/satoshilabs/slips/blob/master/slip-0010.md#test-vector-1-for-secp256k1
let fingerprintTestVectorData =
    """
    [
        {
            "hexEncodedPublicKey": "0339a36013301597daef41fbe593a02cc513d0b55527ec2df1050e2e8ff49c85c2",
            "hexEncodedPublicKeyFingerprint": "3442193e",
        },
        {
            "hexEncodedPublicKey": "0384610f5ecffe8fda089363a41f56a5c7ffc1d81b59a612d0d649b2d22355590c",
            "hexEncodedPublicKeyFingerprint": "9b02312f",
        },
        {
            "hexEncodedPublicKey": "03526c63f8d0b4bbbf9c80df553fe66742df4676b241dabefdef67733e070f6844",
            "hexEncodedPublicKeyFingerprint": "b98005c1",
        },
        {
            "hexEncodedPublicKey": "0359cf160040778a4b14c5f4d7b76e327ccc8c4a6086dd9451b7482b5a4972dda0",
            "hexEncodedPublicKeyFingerprint": "0e9f3274",
        },
        {
            "hexEncodedPublicKey": "029f871f4cb9e1c97f9f4de9ccd0d4a2f2a171110c61178f84430062230833ff20",
            "hexEncodedPublicKeyFingerprint": "8b2b5c4b",
        },
    ]
    """
    .data(using: .utf8)!
