import XCTest
@testable import BIP32

final class SerializedKeyCoderTests: XCTestCase {
    private func sut() -> SerializedKeyCoder {
        .init()
    }

    func testGivenVectorHex_WhenEncode_ThenEqualVectorKey() throws {
        let data = Data(hex: SerializedKeyTestVector.hexEncodedKey)
        let serializedKey = try SerializedKey(data: data)
        let encodedKey = sut().encode(serializedKey: serializedKey)
        XCTAssertEqual(encodedKey, SerializedKeyTestVector.base58CheckEncodedKey)
    }

    func testGivenVectorKey_WhenDecode_ThenEqualVectorHex() throws {
        let hexEncodedKey = try sut()
            .decode(string: SerializedKeyTestVector.base58CheckEncodedKey)
            .data
            .toHexString()
        XCTAssertEqual(hexEncodedKey, SerializedKeyTestVector.hexEncodedKey)
    }
}
