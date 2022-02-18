import XCTest
@testable import BIP32

final class KeyIndexValidatorTests: XCTestCase {
    private func sut() -> KeyIndexValidator {
        .init()
    }

    func testGivenNormalIndex_AndUnhardenedIndication_WhenValidate_ThenValidIndex() {
        testValidIndex(
            0x1,
            isHardened: false
        )
    }

    func testGivenNormalLowerBoundIndex_AndUnhardenedIndication_WhenValidate_ThenValidIndex() {
        testValidIndex(
            KeyIndexRange.normal.lowerBound,
            isHardened: false
        )
    }

    func testGivenNormalUpperBoundIndex_AndUnhardenedIndication_WhenValidate_ThenValidIndex() {
        testValidIndex(
            KeyIndexRange.normal.upperBound,
            isHardened: false
        )
    }

    func testGivenHardenedIndex_AndHardenedIndication_WhenValidate_ThenValidIndex() {
        testValidIndex(
            0x80000001,
            isHardened: true
        )
    }

    func testGivenHardenedLowerBoundIndex_AndHardenedIndication_WhenValidate_ThenValidIndex() {
        testValidIndex(
            KeyIndexRange.hardened.lowerBound,
            isHardened: true
        )
    }

    func testGivenHardenedUpperBoundIndex_AndHardenedIndication_WhenValidate_ThenValidIndex() {
        testValidIndex(
            KeyIndexRange.hardened.upperBound,
            isHardened: true
        )
    }

    func testGivenNormalIndex_AndHardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            0x1,
            isHardened: true,
            expectedError: .invalidIndex
        )
    }

    func testGivenNormalLowerBoundIndex_AndHardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            KeyIndexRange.normal.lowerBound,
            isHardened: true,
            expectedError: .invalidIndex
        )
    }

    func testGivenNormalUpperBoundIndex_AndHardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            KeyIndexRange.normal.upperBound,
            isHardened: true,
            expectedError: .invalidIndex
        )
    }

    func testGivenNormalUpperBoundIndexPlus1_AndUnhardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            KeyIndexRange.normal.upperBound + 1,
            isHardened: false,
            expectedError: .invalidIndex
        )
    }

    func testGivenHardenedIndex_AndUnhardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            0x80000001,
            isHardened: false,
            expectedError: .invalidIndex
        )
   }

    func testGivenHardenedLowerBoundIndex_AndUnhardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            KeyIndexRange.hardened.lowerBound,
            isHardened: false,
            expectedError: .invalidIndex
        )
    }

    func testGivenHardenedLowerBoundIndexMinus1_AndHardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            KeyIndexRange.hardened.lowerBound - 1,
            isHardened: true,
            expectedError: .invalidIndex
        )
    }

    func testGivenHardenedUpperBoundIndex_AndUnhardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            KeyIndexRange.hardened.upperBound,
            isHardened: false,
            expectedError: .invalidIndex
        )
    }
}

// MARK: - Helpers
fileprivate extension KeyIndexValidatorTests {
    func testValidIndex(_ index: UInt32, isHardened: Bool) {
        XCTAssertNoThrow(
            try sut().validateIndex(index, isHardened: isHardened)
        )
    }

    func testInvalidIndex(_ index: UInt32, isHardened: Bool, expectedError: KeyIndexError) {
        XCTAssertThrowsError(
            try sut().validateIndex(index, isHardened: isHardened)
        ) { error in
            XCTAssertEqual(
                error as! KeyIndexError,
                expectedError
            )
        }
    }
}
