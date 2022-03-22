import XCTest
import CryptoSwift
@testable import BIP32

final class SerializedKeyTests: XCTestCase {
    private func sut(data: Data, accessControl: KeyAccessControl) throws -> SerializedKey {
        try .init(data: data, accessControl: accessControl)
    }

    func testGivenKey_WithInvalidByteCount_WhenInit_ThenThrowError() {
        XCTAssertThrowsError(
            try sut(data: .init(), accessControl: .`private`)
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

    func testGivenValidKey_WithPrivateAccessControl_WhenCountKeyBytes_ThenEqual33() throws {
        XCTAssertEqual(
            try validKey(accessControl: .`private`).key.count, 33
        )
    }

    func testGivenValidKey_WithPublicAccessControl_WhenCountKeyBytes_ThenEqual33() throws {
        XCTAssertEqual(
            try validKey(accessControl: .`public`).key.count, 33
        )
    }
}

// MARK: - Helpers
fileprivate extension SerializedKeyTests {
    func validKey(accessControl: KeyAccessControl = .`private`) throws -> SerializedKey {
        let data = Data(hex: SerializedKeyTestVector.hexEncodedKey)
        return try sut(data: data, accessControl: accessControl)
    }
}
