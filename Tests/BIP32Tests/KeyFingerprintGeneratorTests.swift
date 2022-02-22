import XCTest
import CryptoSwift
@testable import BIP32

final class KeyFingerprintGeneratorTests: XCTestCase {
    private var testVectors: [KeyFingerprintTestVector]!

    override func setUpWithError() throws {
        testVectors = try JSONDecoder().decode([KeyFingerprintTestVector].self, from: keyFingerprintTestVectorData)
    }

    private func sut() -> KeyFingerprintGenerator {
        .init()
    }

    func testGivenVectors_WhenCount_ThenEqual5() {
        XCTAssertEqual(testVectors.count, 5)
    }

    func testGivenVectorPublicKey_WhenGenerateFingerprint_ThenEqualVectorFingerprint() throws {
        for testVector in testVectors {
            let publicKey = Data(hex: testVector.hexEncodedPublicKey)
            let hexEncodedFingerprint = sut()
                .fingerprint(publicKey: publicKey)
                .bytes
                .toHexString()
            XCTAssertEqual(hexEncodedFingerprint, testVector.hexEncodedPublicKeyFingerprint)
        }
    }
}
