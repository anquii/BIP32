import XCTest
import CryptoSwift
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
        let compressedWIF = try sut().decode(string: CompressedWIFTestVector.wifCompressedPrivateKey)
        XCTAssertEqual(compressedWIF.privateKey.toHexString(), CompressedWIFTestVector.hexEncodedPrivateKey)
        XCTAssertEqual(compressedWIF.version, CompressedWIFTestVector.version)
    }

    func testGivenVectorWIF_WhenDecode_ThenInvalidDecoding() throws {
        XCTAssertThrowsError(
            try sut().decode(string: CompressedWIFTestVector.wifEncodedPrivateKey)
        )
    }
}
