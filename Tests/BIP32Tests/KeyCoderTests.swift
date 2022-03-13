import XCTest
import CryptoSwift
@testable import BIP32

final class KeyCoderTests: XCTestCase {
    private func sut() -> KeyCoder {
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
