import Foundation
import XCTest
import BIP32

final class KeySerializerTests: XCTestCase {
    private func sut() -> KeySerializer {
        .init()
    }

    func testGivenExtendedKey_AndAttributes_WhenSerialize_ThenNoErrorThrown() throws {
        let seed = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let extendedKey = try PrivateMasterKeyDerivator().privateKey(seed: seed)
        let keyVersion = KeyVersion(network: .mainnet, keyAccessControl: .`private`).wrappedValue
        let keyAttributes = MasterKeyAttributes(accessControl: .`private`, version: keyVersion)

        XCTAssertNoThrow(
            try sut().serializedKey(extendedKey: extendedKey, attributes: keyAttributes)
        )
    }
}
