import XCTest
import Base58Check
@testable import BIP32

final class PrivateMasterKeyDerivatorTests: XCTestCase {
    private func sut() -> PrivateMasterKeyDerivator {
        .init()
    }

    func testGivenSeed_WhenDerivate_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try privateMasterKey()
        )
    }

    func testGivenSeed_WhenDerivate_AndCountKeyBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try privateMasterKey().key.count, 32
        )
    }

    func testGivenSeed_WhenDerivate_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try privateMasterKey().chainCode.count, 32
        )
    }
}

// MARK: - Helpers
fileprivate extension PrivateMasterKeyDerivatorTests {
    func privateMasterKey() throws -> ExtendedKeyable {
        try sut().privateMasterKey(seed: seedTestData)
    }
}
