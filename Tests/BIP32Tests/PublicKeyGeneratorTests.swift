import XCTest
import CryptoSwift
@testable import BIP32

final class PublicKeyGeneratorTests: XCTestCase {
    private func sut() -> PublicKeyGenerator {
        .init()
    }

    func testGivenSerializedKey_WhenGenerate_AndCountKeyBytes_ThenEqual33() throws {
        XCTAssertEqual(
            try publicKey().key.count, 33
        )
    }

    func testGivenSerializedKey_WhenGenerate_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try publicKey().chainCode.count, 32
        )
    }
}

// MARK: - Helpers
extension PublicKeyGeneratorTests {
    func publicKey() throws -> ExtendedKeyable {
        let serializedKey = try SerializedKey(data: testData())
        return sut().publicKey(serializedKey: serializedKey, format: .compressed)
    }

    func testData() -> Data {
        let hexEncodedData =
            """
            0488ade4000000000000000000873dff81c02f5
            25623fd1fe5167eac3a55a049de3d314bb42ee2
            27ffed37d50800e8f32e723decf4051aefac8e2
            c93c9c5b214313817cdb01a1494b917c8436b35
            """
            .components(separatedBy: .newlines)
            .joined()
        return .init(
            hex: hexEncodedData
        )
    }
}
