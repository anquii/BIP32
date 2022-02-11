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

    func testGivenSeed_WhenGenerate_AndCountMasterPrivateKeyBytes_ThenEqual32() throws {
        let extendedKey = try sut().masterKey(seed: testSeed())
        let masterPrivateKeyByteCount = extendedKey.key.count
        XCTAssertEqual(masterPrivateKeyByteCount, 32)
    }

    func testGivenSeed_WhenGenerate_AndCountMasterChainCodeBytes_ThenEqual32() throws {
        let extendedKey = try sut().masterKey(seed: testSeed())
        let masterChainCodeByteCount = extendedKey.chainCode.count
        XCTAssertEqual(masterChainCodeByteCount, 32)
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
