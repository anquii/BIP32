import XCTest
import Base58Check
@testable import BIP32

final class MasterPrivateKeyGeneratorTests: XCTestCase {
    private func sut() -> MasterPrivateKeyGenerator {
        .init()
    }

    func testGivenSeed_WhenGenerate_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try masterPrivateKey()
        )
    }

    func testGivenSeed_WhenGenerate_AndCountKeyBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try masterPrivateKey().key.count, 32
        )
    }

    func testGivenSeed_WhenGenerate_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try masterPrivateKey().chainCode.count, 32
        )
    }
}

// MARK: - Helpers
fileprivate extension MasterPrivateKeyGeneratorTests {
    func masterPrivateKey() throws -> ExtendedKeyable {
        try sut().masterPrivateKey(seed: seedTestData)
    }
}
