import XCTest
@testable import BIP32

final class KeyIndexContainerTests: XCTestCase {
    private func sut(index: UInt32, shouldHarden: Bool) throws -> KeyIndexContainer {
        try .init(index: index, shouldHarden: shouldHarden)
    }

    func testGivenNormalIndex_AndShouldNotHarden_WhenInit_AndGetIndex_ThenSameIndex() throws {
        try testValidIndex(
            0x1,
            shouldHarden: false,
            expectedIndexOutput: 0x1
        )
    }

    func testGivenNormalLowerBoundIndex_AndShouldNotHarden_WhenInit_AndGetIndex_ThenSameIndex() throws {
        try testValidIndex(
            KeyDerivationRange.normal.lowerBound,
            shouldHarden: false,
            expectedIndexOutput: KeyDerivationRange.normal.lowerBound
        )
    }

    func testGivenNormalUpperBoundIndex_AndShouldNotHarden_WhenInit_AndGetIndex_ThenSameIndex() throws {
        try testValidIndex(
            KeyDerivationRange.normal.upperBound,
            shouldHarden: false,
            expectedIndexOutput: KeyDerivationRange.normal.upperBound
        )
    }

    func testGivenNormalIndex_AndShouldHarden_WhenInit_AndGetIndex_ThenHardenedIndex() throws {
        try testValidIndex(
            0x1,
            shouldHarden: true,
            expectedIndexOutput: 0x80000001
        )
    }

    func testGivenNormalLowerBoundIndex_AndShouldHarden_WhenInit_AndGetIndex_ThenHardenedLowerBoundIndex() throws {
        try testValidIndex(
            KeyDerivationRange.normal.lowerBound,
            shouldHarden: true,
            expectedIndexOutput: KeyDerivationRange.hardened.lowerBound
        )
    }

    func testGivenNormalUpperBoundIndex_AndShouldHarden_WhenInit_AndGetIndex_ThenHardenedUpperBoundIndex() throws {
        try testValidIndex(
            KeyDerivationRange.normal.upperBound,
            shouldHarden: true,
            expectedIndexOutput: KeyDerivationRange.hardened.upperBound
        )
    }

    func testGivenHardenedIndex_AndShouldHarden_WhenInit_ThenThrowMemorySpaceExeededError() {
        testInvalidIndex(
            0x80000001,
            shouldHarden: true,
            expectedError: .memorySpaceExceeded
        )
    }
}

// MARK: - Helpers
extension KeyIndexContainerTests {
    func testValidIndex(_ index: UInt32, shouldHarden: Bool, expectedIndexOutput: UInt32) throws {
        XCTAssertEqual(
            try sut(index: index, shouldHarden: shouldHarden).index,
            expectedIndexOutput
        )
    }

    func testInvalidIndex(_ index: UInt32, shouldHarden: Bool, expectedError: KeyIndexError) {
        XCTAssertThrowsError(
            try sut(index: index, shouldHarden: shouldHarden)
        ) { error in
            XCTAssertEqual(
                error as! KeyIndexError,
                expectedError
            )
        }
    }
}
