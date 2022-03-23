import Foundation
import XCTest
@testable import BIP32

final class KeyFingerprintDerivatorTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [KeyFingerprintTestVector]!

    override func setUpWithError() throws {
        testVectors = try jsonDecoder.decode([KeyFingerprintTestVector].self, from: keyFingerprintTestData)
    }

    private func sut() -> KeyFingerprintDerivator {
        .init()
    }

    func testGivenVectorPublicKey_WhenDerivateFingerprint_ThenEqualVectorFingerprint() throws {
        for testVector in testVectors {
            let publicKey = Data(hex: testVector.hexEncodedPublicKey)
            let fingerprintBytes = sut()
                .fingerprint(publicKey: publicKey)
                .bytes
            let expectedFingerprintBytes = UInt32(
                data: Data(hex: testVector.hexEncodedPublicKeyFingerprint)
            )!.bytes
            XCTAssertEqual(fingerprintBytes, expectedFingerprintBytes)
        }
    }
}
