import XCTest
import CryptoSwift
@testable import BIP32

final class MasterKeySerializerTests: XCTestCase {
    private let masterKeyGenerator = MasterKeyGenerator()
    private let bitcoinVersionContainer = BitcoinVersionContainer(
        network: .mainnet,
        keyAccessControl: .private
    )

    private func sut() -> MasterKeySerializer {
        .init()
    }

    func testGivenMasterKey_AndVersion_WhenSerialize_ThenNoErrorThrown() throws {
        XCTAssertNoThrow(
            try serializedKey()
        )
    }

    func testGivenSerializedKey_WhenMainnet_AndPrivateAccessControl_AndGetVersion_ThenEqual() throws {
        XCTAssertEqual(
            try serializedKey().version, 0x0488ADE4
        )
    }

    func testGivenSerializedKey_WhenGetDepth_ThenEqual0() throws {
        XCTAssertEqual(
            try serializedKey().depth, 0
        )
    }

    func testGivenSerializedKey_WhenGetFingerprint_ThenEqual0() throws {
        XCTAssertEqual(
            try serializedKey().fingerprint, 0
        )
    }

    func testGivenSerializedKey_WhenGetIndex_ThenEqual0() throws {
        XCTAssertEqual(
            try serializedKey().index, 0
        )
    }
}

// MARK: - Helpers
extension MasterKeySerializerTests {
    func serializedKey() throws -> SerializedKeyable {
        let masterKey = try masterKeyGenerator.masterKey(
            seed: testSeed()
        )
        let serializedKey = try sut().serializedKey(
            extendedKey: masterKey,
            version: bitcoinVersionContainer.version
        )
        return serializedKey
    }

    func testSeed() -> Data {
        .init(hex: "000102030405060708090a0b0c0d0e0f")
    }
}
