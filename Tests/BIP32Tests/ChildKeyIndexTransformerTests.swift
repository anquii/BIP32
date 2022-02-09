import XCTest
@testable import BIP32

final class ChildKeyIndexTransformerTests: XCTestCase {
    private func sut() -> ChildKeyIndexTransformer {
        .init()
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
            ChildKeyDerivationRange.normal.lowerBound,
            shouldHarden: false,
            expectedIndexOutput: ChildKeyDerivationRange.normal.lowerBound
        )
    }

    func testGivenNormalUpperBoundIndex_AndShouldNotHarden_WhenInit_AndGetIndex_ThenSameIndex() throws {
        try testValidIndex(
            ChildKeyDerivationRange.normal.upperBound,
            shouldHarden: false,
            expectedIndexOutput: ChildKeyDerivationRange.normal.upperBound
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
            ChildKeyDerivationRange.normal.lowerBound,
            shouldHarden: true,
            expectedIndexOutput: ChildKeyDerivationRange.hardened.lowerBound
        )
    }

    func testGivenNormalUpperBoundIndex_AndShouldHarden_WhenInit_AndGetIndex_ThenHardenedUpperBoundIndex() throws {
        try testValidIndex(
            ChildKeyDerivationRange.normal.upperBound,
            shouldHarden: true,
            expectedIndexOutput: ChildKeyDerivationRange.hardened.upperBound
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
extension ChildKeyIndexTransformerTests {
    func testValidIndex(_ index: UInt32, shouldHarden: Bool, expectedIndexOutput: UInt32) throws {
        XCTAssertEqual(
            try sut().index(index, shouldHarden: shouldHarden),
            expectedIndexOutput
        )
    }

    func testInvalidIndex(_ index: UInt32, shouldHarden: Bool, expectedError: ChildKeyIndexError) {
        XCTAssertThrowsError(
            try sut().index(index, shouldHarden: shouldHarden)
        ) { error in
            XCTAssertEqual(
                error as! ChildKeyIndexError,
                expectedError
            )
        }
    }
}
