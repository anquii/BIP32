import XCTest
import CryptoSwift
@testable import BIP32

final class KeyCoderTests: XCTestCase {
    private var testVectors: [KeyCoderTestVector]!

    override func setUpWithError() throws {
        testVectors = try JSONDecoder().decode([KeyCoderTestVector].self, from: keyCoderTestVectorData)
    }

    private func sut() -> KeyCoder {
        .init()
    }

    func testGivenVectorHex_WhenEncode_ThenEqualVectorKey() throws {
        let data = Data(hex: SerializedKeyTestVector.hexEncodedKey)
        let serializedKey = try SerializedKey(data: data, accessControl: .`private`)
        let encodedKey = sut().encode(serializedKey: serializedKey)
        XCTAssertEqual(encodedKey, SerializedKeyTestVector.base58CheckEncodedKey)
    }

    func testGivenVectorKey_WhenDecode_ThenEqualVectorHex() throws {
        let hexEncodedKey = try sut()
            .decode(string: SerializedKeyTestVector.base58CheckEncodedKey, accessControl: .`private`)
            .data
            .toHexString()
        XCTAssertEqual(hexEncodedKey, SerializedKeyTestVector.hexEncodedKey)
    }

    func testGivenInvalidEncodedKey_WhenDecode_ThenInvalidDecoding() {
        let sut = self.sut()

        for testVector in testVectors {
            let keyAccessControl: KeyAccessControl = testVector.isPrivate ? .`private` : .`public`
            XCTAssertThrowsError(
                try sut.decode(string: testVector.base58CheckEncodedKey, accessControl: keyAccessControl),
                testVector.base58CheckEncodedKey
            )
        }
    }
}
