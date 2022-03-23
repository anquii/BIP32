import Foundation
import XCTest
import BIP32

final class SerializedKeyValidatorTests: XCTestCase {
    private let serializedKeyCoder = SerializedKeyCoder()
    private let jsonDecoder = JSONDecoder()
    private var invalidTestVectors: [SerializedKeyValidatorTestVector]!
    private var validPrivateMasterKeyTestVectors: [MasterKeyTestVector]!
    private var validPublicMasterKeyTestVectors: [MasterKeyTestVector]!

    override func setUpWithError() throws {
        invalidTestVectors = try jsonDecoder.decode([SerializedKeyValidatorTestVector].self, from: serializedKeyValidatorTestData)
        validPrivateMasterKeyTestVectors = try jsonDecoder.decode([MasterKeyTestVector].self, from: privateMasterKeyTestData)
        validPublicMasterKeyTestVectors = try jsonDecoder.decode([MasterKeyTestVector].self, from: publicMasterKeyTestData)
    }

    private func sut() -> SerializedKeyValidator {
        .init()
    }

    func testGivenVector_WithInvalidEncodedKey_WhenValidate_ThenThrowError() {
        let sut = self.sut()

        for testVector in invalidTestVectors {
            let keyAccessControl: KeyAccessControl = testVector.isPrivate ? .`private` : .`public`
            if let serializedKey = try? serializedKeyCoder.decode(string: testVector.base58CheckEncodedKey) {
                XCTAssertThrowsError(
                    try sut.validate(serializedKey: serializedKey, keyAccessControl: keyAccessControl)
                )
            }
        }
    }

    func testGivenValidEncodedPrivateKey_WhenValidate_ThenNoErrorThrown() throws {
        let sut = self.sut()

        for testVector in validPrivateMasterKeyTestVectors {
            let serializedKey = try serializedKeyCoder.decode(string: testVector.base58CheckEncodedKey)
            XCTAssertNoThrow(
                try sut.validate(serializedKey: serializedKey, keyAccessControl: .`private`)
            )
        }
    }

    func testGivenValidEncodedPublicKey_WhenValidate_ThenNoErrorThrown() throws {
        let sut = self.sut()

        for testVector in validPublicMasterKeyTestVectors {
            let serializedKey = try serializedKeyCoder.decode(string: testVector.base58CheckEncodedKey)
            XCTAssertNoThrow(
                try sut.validate(serializedKey: serializedKey, keyAccessControl: .`public`)
            )
        }
    }
}
