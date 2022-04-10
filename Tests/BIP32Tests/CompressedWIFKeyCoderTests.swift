import XCTest
@testable import BIP32

final class CompressedWIFKeyCoderTests: XCTestCase {
    private func sut() -> CompressedWIFKeyCoder {
        .init()
    }

    func testGivenVectorHex_WhenEncode_ThenEqualVectorWIF() throws {
        let data = Data(hex: CompressedWIFTestVector.hexEncodedPrivateKey)
        let encodedKey = sut().encode(privateKey: data, version: CompressedWIFTestVector.version)
        XCTAssertEqual(encodedKey, CompressedWIFTestVector.wifCompressedPrivateKey)
    }

    func testGivenVectorWIF_WhenDecode_ThenEqualVectorHex() throws {
        let decodedResult = try sut().decode(string: CompressedWIFTestVector.wifCompressedPrivateKey)
        XCTAssertEqual(decodedResult.privateKey.toHexString(), CompressedWIFTestVector.hexEncodedPrivateKey)
        XCTAssertEqual(decodedResult.version, CompressedWIFTestVector.version)
    }

    func testGivenVectorWIF_WhenDecode_ThenInvalidDecoding() {
        XCTAssertThrowsError(
            try sut().decode(string: CompressedWIFTestVector.wifEncodedPrivateKey)
        )
    }
}
