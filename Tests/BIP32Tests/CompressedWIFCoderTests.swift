import XCTest
@testable import BIP32

final class CompressedWIFCoderTests: XCTestCase {
    private func sut() -> CompressedWIFCoder {
        .init()
    }

    func testGivenVectorHex_WhenEncode_ThenEqualVectorWIF() throws {
        let data = Data(hex: CompressedWIFTestVector.hexEncodedPrivateKey)
        let encodedKey = sut().encode(privateKey: data, version: CompressedWIFTestVector.version)
        XCTAssertEqual(encodedKey, CompressedWIFTestVector.wifCompressedPrivateKey)
    }

    func testGivenVectorCompressedWIF_WhenDecode_ThenEqualVectorHex() throws {
        let compressedWIFContainer = try sut().decode(string: CompressedWIFTestVector.wifCompressedPrivateKey)
        XCTAssertEqual(compressedWIFContainer.privateKey.toHexString(), CompressedWIFTestVector.hexEncodedPrivateKey)
        XCTAssertEqual(compressedWIFContainer.version, CompressedWIFTestVector.version)
    }

    func testGivenVectorWIF_WhenDecode_ThenInvalidDecoding() {
        XCTAssertThrowsError(
            try sut().decode(string: CompressedWIFTestVector.wifEncodedPrivateKey)
        )
    }
}
