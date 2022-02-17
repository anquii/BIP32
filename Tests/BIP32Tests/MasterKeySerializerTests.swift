import XCTest
import CryptoSwift
@testable import BIP32

final class MasterKeySerializerTests: XCTestCase {
    private let masterKeyGenerator = MasterKeyGenerator()

    private func sut() -> MasterKeySerializer {
        .init()
    }

    func testGivenMasterKey_AndVersion_WhenSerialize_ThenNoErrorThrown() throws {
        XCTAssertNoThrow(
            try serializedMasterKey()
        )
    }

    func testGivenSerializedMasterKey_WhenMainnet_AndPrivateAccessControl_AndGetVersion_ThenEqual() throws {
        XCTAssertEqual(
            try serializedMasterKey().version, 0x0488ADE4
        )
    }

    func testGivenSerializedMasterKey_WhenGetDepth_ThenEqual0() throws {
        XCTAssertEqual(
            try serializedMasterKey().depth, 0
        )
    }

    func testGivenSerializedMasterKey_WhenGetFingerprint_ThenEqual0() throws {
        XCTAssertEqual(
            try serializedMasterKey().fingerprint, 0
        )
    }

    func testGivenSerializedMasterKey_WhenGetIndex_ThenEqual0() throws {
        XCTAssertEqual(
            try serializedMasterKey().index, 0
        )
    }

    func testGivenSerializedMasterKey_WhenGetKeyPrefix_ThenEqual0() throws {
        XCTAssertEqual(
            try serializedMasterKey().key.first, 0
        )
    }
}

// MARK: - Helpers
extension MasterKeySerializerTests {
    func serializedMasterKey() throws -> SerializedKeyable {
        let masterKey = try masterKeyGenerator.masterKey(
            seed: testSeed()
        )
        let serializedMasterKey = try sut().serializedMasterKey(
            extendedKey: masterKey,
            version: 0x0488ADE4
        )
        return serializedMasterKey
    }

    func testSeed() -> Data {
        .init(hex: "000102030405060708090a0b0c0d0e0f")
    }
}
