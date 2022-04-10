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

    func testGivenVectorPublicKey_WhenDerivateFingerprint_AndCountBytes_ThenEqual4() throws {
        let publicKey = Data(hex: testVectors.first!.hexEncodedPublicKey)
        let fingerprint = sut().fingerprint(publicKey: publicKey)
        XCTAssertEqual(fingerprint.bytes.count, 4)
    }

    func testGivenVectorPublicKey_WhenDerivateFingerprintAndHash160_AndCountBytes_ThenEqual4And20() throws {
        let publicKey = Data(hex: testVectors.first!.hexEncodedPublicKey)
        let fingerprintAndHash160 = sut().fingerprintAndHash160(publicKey: publicKey)
        XCTAssertEqual(fingerprintAndHash160.fingerprint.bytes.count, 4)
        XCTAssertEqual(fingerprintAndHash160.hash160.count, 20)
    }

    func testGivenVectorPublicKey_WhenDerivateFingerprint_ThenEqualVectorFingerprint() throws {
        for testVector in testVectors {
            let publicKey = Data(hex: testVector.hexEncodedPublicKey)
            let fingerprint = sut().fingerprint(publicKey: publicKey)
            let expectedFingerprint = UInt32(data: Data(hex: testVector.hexEncodedPublicKeyFingerprint))!
            XCTAssertEqual(fingerprint, expectedFingerprint)
        }
    }

    func testGivenVectorPublicKey_WhenDerivateFingerprintAndHash160_ThenEqualVectorFingerprintAndHash160() throws {
        for testVector in testVectors {
            let publicKey = Data(hex: testVector.hexEncodedPublicKey)
            let fingerprintAndHash160 = sut().fingerprintAndHash160(publicKey: publicKey)
            let expectedFingerprint = UInt32(data: Data(hex: testVector.hexEncodedPublicKeyFingerprint))!
            XCTAssertEqual(fingerprintAndHash160.fingerprint, expectedFingerprint)
            XCTAssertEqual(fingerprintAndHash160.hash160.toHexString(), testVector.hexEncodedPublicKeyHash160)
        }
    }
}
