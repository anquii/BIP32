/// https://github.com/satoshilabs/slips/blob/master/slip-0010.md#test-vector-1-for-secp256k1
let keyFingerprintTestData =
    """
    [
        {
            "hexEncodedPublicKey": "0339a36013301597daef41fbe593a02cc513d0b55527ec2df1050e2e8ff49c85c2",
            "hexEncodedPublicKeyFingerprint": "3442193e",
            "hexEncodedPublicKeyHash160": "3442193e1bb70916e914552172cd4e2dbc9df811"
        },
        {
            "hexEncodedPublicKey": "0384610f5ecffe8fda089363a41f56a5c7ffc1d81b59a612d0d649b2d22355590c",
            "hexEncodedPublicKeyFingerprint": "9b02312f",
            "hexEncodedPublicKeyHash160": "9b02312f35c66826c3afe35600c3648ed0d4bf4c"
        },
        {
            "hexEncodedPublicKey": "03526c63f8d0b4bbbf9c80df553fe66742df4676b241dabefdef67733e070f6844",
            "hexEncodedPublicKeyFingerprint": "b98005c1",
            "hexEncodedPublicKeyHash160": "b98005c1aa576c251989ad7bf48ad0db3fd17dd2"
        },
        {
            "hexEncodedPublicKey": "0359cf160040778a4b14c5f4d7b76e327ccc8c4a6086dd9451b7482b5a4972dda0",
            "hexEncodedPublicKeyFingerprint": "0e9f3274",
            "hexEncodedPublicKeyHash160": "0e9f327461591208884f5fb53677b4c539469d0c"
        },
        {
            "hexEncodedPublicKey": "029f871f4cb9e1c97f9f4de9ccd0d4a2f2a171110c61178f84430062230833ff20",
            "hexEncodedPublicKeyFingerprint": "8b2b5c4b",
            "hexEncodedPublicKeyHash160": "8b2b5c4b19760515cac18215582c613ef6f6e06b"
        }
    ]
    """
    .data(using: .utf8)!
