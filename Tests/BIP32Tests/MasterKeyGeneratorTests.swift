import XCTest
@testable import BIP32

final class MasterKeyGeneratorTests: XCTestCase {
    private func sut() -> MasterKeyGenerator {
        .init()
    }

    func testGivenSeed_WhenGenerate_ThenAssertNoThrow() {
        XCTAssertNoThrow(
            try sut().masterKey(seed: testSeed())
        )
    }

    func testGivenSeed_WhenGenerate_AndCountKeyBytes_ThenEqual32() throws {
        let extendedKey = try sut().masterKey(seed: testSeed())
        XCTAssertEqual(extendedKey.key.count, 32)
    }

    func testGivenSeed_WhenGenerate_AndCountChainCodeBytes_ThenEqual32() throws {
        let extendedKey = try sut().masterKey(seed: testSeed())
        XCTAssertEqual(extendedKey.chainCode.count, 32)
    }
}

// MARK: - Helpers
extension MasterKeyGeneratorTests {
    func testSeed() -> Data {
        let hexEncodedSeed =
            """
            c55257c360c07c72029aebc1b53c05ed
            0362ada38ead3e3e9efa3708e5349553
            1f09a6987599d18264c1e1c92f2cf141
            630c7a3c4ab7c81b2f001698e7463b04
            """
        return .init(
            hex: hexEncodedSeed
        )
    }
}
