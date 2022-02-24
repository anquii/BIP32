import XCTest
@testable import BIP32

final class KeySerializerTests: XCTestCase {
    private func sut() -> KeySerializer {
        .init()
    }

    func testGivenExtendedKey_AndAttributes_WhenSerialize_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try serializedKey()
        )
    }
}

// MARK: - Helpers
fileprivate extension KeySerializerTests {
    func serializedKey() throws -> SerializedKeyable {
        let extendedKey = try PrivateMasterKeyGenerator().privateMasterKey(seed: seedTestData)
        let versionContainer = BitcoinVersionContainer(network: .mainnet, keyAccessControl: .private)
        let attributes = MasterKeyAttributes(accessControl: .private, version: versionContainer.version)
        return try sut().serializedKey(extendedKey: extendedKey, attributes: attributes)
    }
}
