import XCTest
import CryptoSwift
@testable import BIP32

final class KeySerializerTests: XCTestCase {
    private func sut() -> KeySerializer {
        .init()
    }

    func testGivenExtendedKey_AndAttributes_WhenSerialize_ThenNoErrorThrown() throws {
        let seed = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let extendedKey = try PrivateMasterKeyDerivator().privateMasterKey(seed: seed)
        let versionContainer = BitcoinVersionContainer(network: .mainnet, keyAccessControl: .`private`)
        let attributes = MasterKeyAttributes(accessControl: .`private`, version: versionContainer.version)

        XCTAssertNoThrow(
            try sut().serializedKey(extendedKey: extendedKey, attributes: attributes)
        )
    }
}
