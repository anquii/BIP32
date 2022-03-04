import XCTest
import CryptoSwift
@testable import BIP32

final class SerializedKeyTests: XCTestCase {
    private func sut(data: Data) throws -> SerializedKey {
        try .init(data: data)
    }

    func testGivenInvalidData_WhenInit_ThenThrowError() {
        XCTAssertThrowsError(
            try sut(data: .init())
        )
    }

    func testGivenValidData_WhenInit_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try sut(data: testData())
        )
    }

    func testGivenValidKey_WhenCountVersionBytes_ThenEqual4() throws {
        XCTAssertEqual(
            try validKey().version.bytes.count, 4
        )
    }

    func testGivenValidKey_WhenCountDepthBytes_ThenEqual1() throws {
        XCTAssertEqual(
            try validKey().depth.bytes.count, 1
        )
    }

    func testGivenValidKey_WhenCountParentKeyFingerprintBytes_ThenEqual4() throws {
        XCTAssertEqual(
            try validKey().parentKeyFingerprint.bytes.count, 4
        )
    }

    func testGivenValidKey_WhenCountIndexBytes_ThenEqual4() throws {
        XCTAssertEqual(
            try validKey().index.bytes.count, 4
        )
    }

    func testGivenValidKey_WhenCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try validKey().extendedKey.chainCode.count, 32
        )
    }

    func testGivenValidKey_WhenCountKeyBytes_ThenEqual33() throws {
        XCTAssertEqual(
            try validKey().extendedKey.key.count, 33
        )
    }
}

// MARK: - Helpers
fileprivate extension SerializedKeyTests {
    func validKey() throws -> SerializedKey {
        try sut(data: testData())
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

        return .init(hex: hexEncodedData)
    }
}
