import XCTest
import CryptoSwift
@testable import BIP32

final class KeyFingerprintGeneratorTests: XCTestCase {
    private var testVectors: [FingerprintTestVector]!

    override func setUpWithError() throws {
        testVectors = try JSONDecoder().decode([FingerprintTestVector].self, from: fingerprintTestVectorData)
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
            let hexEncodedFingerprint = try sut()
                .fingerprint(publicKey: publicKey)
                .bytes
                .toHexString()
            XCTAssertEqual(hexEncodedFingerprint, testVector.hexEncodedPublicKeyFingerprint)
        }
    }
}
