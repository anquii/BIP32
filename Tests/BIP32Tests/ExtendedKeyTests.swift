import XCTest
@testable import BIP32

final class ExtendedKeyTests: XCTestCase {
    private func sut(serializedKey: SerializedKeyable, accessControl: KeyAccessControl) -> ExtendedKey {
        .init(serializedKey: serializedKey, accessControl: accessControl)
    }

    func testGivenSerializedKey_WithPrivateAccessControl_WhenInit_AndCountKeyBytes_ThenEqual32() throws {
        let sut = try self.sut(serializedKey: serializedKey(), accessControl: .`private`)
        XCTAssertEqual(sut.key.count, 32)
    }

    func testGivenSerializedKey_WithPublicAccessControl_WhenInit_AndCountKeyBytes_ThenEqual33() throws {
        let sut = try self.sut(serializedKey: serializedKey(), accessControl: .`public`)
        XCTAssertEqual(sut.key.count, 33)
    }
}

// MARK: - Helpers
fileprivate extension ExtendedKeyTests {
    func serializedKey() throws -> SerializedKey {
        let data = Data(hex: SerializedKeyTestVector.hexEncodedKey)
        return try .init(data: data)
    }
}
