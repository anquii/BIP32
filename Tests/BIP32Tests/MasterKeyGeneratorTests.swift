import XCTest
import CryptoSwift
@testable import BIP32

final class MasterKeyGeneratorTests: XCTestCase {
    private func sut() -> MasterKeyGenerator {
        .init()
    }

    func testGivenSeed_WhenGenerate_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try masterKey()
        )
    }

    func testGivenSeed_WhenGenerate_AndCountKeyBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try masterKey().key.count, 32
        )
    }

    func testGivenSeed_WhenGenerate_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try masterKey().chainCode.count, 32
        )
    }
}

// MARK: - Helpers
extension MasterKeyGeneratorTests {
    func masterKey() throws -> ExtendedKeyable {
        try sut().masterKey(seed: testSeed())
    }

    func testSeed() -> Data {
        .init(hex: "000102030405060708090a0b0c0d0e0f")
    }
}
