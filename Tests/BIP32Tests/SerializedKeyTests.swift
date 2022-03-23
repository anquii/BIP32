import XCTest
import CryptoSwift
@testable import BIP32

final class SerializedKeyTests: XCTestCase {
    private func sut(data: Data) throws -> SerializedKey {
        try .init(data: data)
    }

    func testGivenKey_WithInvalidByteCount_WhenInit_ThenThrowError() {
        XCTAssertThrowsError(
            try sut(data: .init())
        )
    }

    func testGivenKey_WithValidByteCount_WhenInit_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try validKey()
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
            try validKey().chainCode.count, 32
        )
    }

    func testGivenValidKey_WhenCountKeyBytes_ThenEqual33() throws {
        XCTAssertEqual(
            try validKey().key.count, 33
        )
    }
}

// MARK: - Helpers
fileprivate extension SerializedKeyTests {
    func validKey() throws -> SerializedKey {
        let data = Data(hex: SerializedKeyTestVector.hexEncodedKey)
        return try sut(data: data)
    }
}
