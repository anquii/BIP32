import BIP32

struct SerializedKeyTestVector {
    static let hexEncodedKey =
        """
        0488ade4000000000000000000873dff81c02f5
        25623fd1fe5167eac3a55a049de3d314bb42ee2
        27ffed37d50800e8f32e723decf4051aefac8e2
        c93c9c5b214313817cdb01a1494b917c8436b35
        """
        .components(separatedBy: .newlines)
        .joined()

    static let base58CheckEncodedKey =
        """
        xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2
        nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWU
        tg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi
        """
        .components(separatedBy: .newlines)
        .joined()

    static let keyAccessControl = KeyAccessControl.`private`

    private init() {}
}
