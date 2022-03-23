import XCTest
import BIP32

final class SerializedKeyValidatorTests: XCTestCase {
    private var serializedKeyCoder: SerializedKeyCoder!
    private var testVectors: [SerializedKeyValidatorTestVector]!

    override func setUpWithError() throws {
        serializedKeyCoder = .init()
        testVectors = try JSONDecoder().decode([SerializedKeyValidatorTestVector].self, from: serializedKeyValidatorTestData)
    }

    private func sut() -> SerializedKeyValidator {
        .init()
    }

    func testGivenVectorEncodedKey_WhenValidate_ThenThrowError() {
        let sut = self.sut()

        for testVector in testVectors {
            let keyAccessControl: KeyAccessControl = testVector.isPrivate ? .`private` : .`public`
            if let serializedKey = try? serializedKeyCoder.decode(string: testVector.base58CheckEncodedKey) {
                XCTAssertThrowsError(
                    try sut.validate(serializedKey: serializedKey, keyAccessControl: keyAccessControl),
                    testVector.base58CheckEncodedKey
                )
            }
        }
    }
}
