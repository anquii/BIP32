import XCTest
@testable import BIP32

final class KeyIndexHardenerTests: XCTestCase {
    private func sut() -> KeyIndexHardener {
        .init()
    }

    func testGivenNormalIndex_WhenHardened_ThenExpectedIndexOutput() throws {
        try testValidIndex(
            0x1,
            expectedIndexOutput: 0x80000001
        )
    }

    func testGivenNormalLowerBoundIndex_WhenHardened_ThenHardenedLowerBoundIndex() throws {
        try testValidIndex(
            KeyIndexRange.normal.lowerBound,
            expectedIndexOutput: KeyIndexRange.hardened.lowerBound
        )
    }

    func testGivenNormalUpperBoundIndex_WhenHardened_ThenHardenedUpperBoundIndex() throws {
        try testValidIndex(
            KeyIndexRange.normal.upperBound,
            expectedIndexOutput: KeyIndexRange.hardened.upperBound
        )
    }

    func testGivenHardenedIndex_WhenHardened_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            0x80000001,
            expectedError: .invalidIndex
        )
    }
}

// MARK: - Helpers
fileprivate extension KeyIndexHardenerTests {
    func testValidIndex(_ index: UInt32, expectedIndexOutput: UInt32) throws {
        XCTAssertEqual(
            try sut().hardenedIndex(normalIndex: index),
            expectedIndexOutput
        )
    }

    func testInvalidIndex(_ index: UInt32, expectedError: KeyIndexError) {
        XCTAssertThrowsError(
            try sut().hardenedIndex(normalIndex: index)
        ) { error in
            XCTAssertEqual(
                error as! KeyIndexError,
                expectedError
            )
        }
    }
}
