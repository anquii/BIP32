import XCTest
@testable import BIP32

final class KeySerializerTests: XCTestCase {
    private func sut() -> KeySerializer {
        .init()
    }

    func testGivenExtendedKey_AndAttributes_WhenSerialize_ThenNoErrorThrown() throws {
        XCTAssertNoThrow(
            try serializedKey()
        )
    }
}

// MARK: - Helpers
extension KeySerializerTests {
    func serializedKey() throws -> SerializedKeyable {
        let extendedKey = try MasterKeyGenerator().masterKey(seed: TestVector.seed)
        let versionContainer = BitcoinVersionContainer(network: .mainnet, keyAccessControl: .private)
        let attributes = MasterKeyAttributes(version: versionContainer.version)
        return try sut().serializedKey(extendedKey: extendedKey, attributes: attributes)
    }
}
