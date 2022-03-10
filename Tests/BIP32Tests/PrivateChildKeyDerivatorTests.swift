import XCTest
@testable import BIP32

final class PrivateChildKeyDerivatorTests: XCTestCase {
    private var privateMasterKeyDerivator: PrivateMasterKeyDerivator!
    private var keyIndexHardener: KeyIndexHardener!

    override func setUpWithError() throws {
        privateMasterKeyDerivator = .init()
        keyIndexHardener = .init()
    }

    private func sut() -> PrivateChildKeyDerivator {
        .init()
    }

    func testGivenPrivateMasterKey_WhenDerivatePrivateChildKey_ThenNoErrorThrown() throws {
        let privateMasterKey = try privateMasterKeyDerivator.privateMasterKey(seed: seedTestData)
        let privateChildKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 0)

        XCTAssertNoThrow(
            try sut().privateChildKey(
                privateParentKey: privateMasterKey,
                index: privateChildKeyIndex
            )
        )
    }
}
