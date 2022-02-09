import XCTest
@testable import BIP32

final class ChildKeyIndexValidatorTests: XCTestCase {
    private func sut() -> ChildKeyIndexValidator {
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
            ChildKeyDerivationRange.normal.lowerBound,
            isHardened: false
        )
    }

    func testGivenNormalUpperBoundIndex_AndUnhardenedIndication_WhenValidate_ThenValidIndex() {
        testValidIndex(
            ChildKeyDerivationRange.normal.upperBound,
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
            ChildKeyDerivationRange.hardened.lowerBound,
            isHardened: true
        )
    }

    func testGivenHardenedUpperBoundIndex_AndHardenedIndication_WhenValidate_ThenValidIndex() {
        testValidIndex(
            ChildKeyDerivationRange.hardened.upperBound,
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
            ChildKeyDerivationRange.normal.lowerBound,
            isHardened: true,
            expectedError: .invalidIndex
        )
    }

    func testGivenNormalUpperBoundIndex_AndHardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            ChildKeyDerivationRange.normal.upperBound,
            isHardened: true,
            expectedError: .invalidIndex
        )
    }

    func testGivenNormalUpperBoundIndexPlus1_AndUnhardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            ChildKeyDerivationRange.normal.upperBound + 1,
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
            ChildKeyDerivationRange.hardened.lowerBound,
            isHardened: false,
            expectedError: .invalidIndex
        )
    }

    func testGivenHardenedLowerBoundIndexMinus1_AndHardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            ChildKeyDerivationRange.hardened.lowerBound - 1,
            isHardened: true,
            expectedError: .invalidIndex
        )
    }

    func testGivenHardenedUpperBoundIndex_AndUnhardenedIndication_WhenValidate_ThenThrowInvalidIndexError() {
        testInvalidIndex(
            ChildKeyDerivationRange.hardened.upperBound,
            isHardened: false,
            expectedError: .invalidIndex
        )
    }
}

// MARK: - Helpers
extension ChildKeyIndexValidatorTests {
    func testValidIndex(_ index: UInt32, isHardened: Bool) {
        XCTAssertNoThrow(
            try sut().validateIndex(index, isHardened: isHardened)
        )
    }

    func testInvalidIndex(_ index: UInt32, isHardened: Bool, expectedError: ChildKeyIndexError) {
        XCTAssertThrowsError(
            try sut().validateIndex(index, isHardened: isHardened)
        ) { error in
            XCTAssertEqual(
                error as! ChildKeyIndexError,
                expectedError
            )
        }
    }
}
