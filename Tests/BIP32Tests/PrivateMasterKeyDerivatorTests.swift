import XCTest
import CryptoSwift
@testable import BIP32

final class PrivateMasterKeyDerivatorTests: XCTestCase {
    private var keyVersion: UInt32!
    private var keyAttributes: MasterKeyAttributes!
    private var keySerializer: KeySerializer!
    private var keyCoder: KeyCoder!
    private var testVectors: [MasterKeyTestVector]!

    override func setUpWithError() throws {
        keyVersion = BitcoinVersionContainer(network: .mainnet, keyAccessControl: .`private`).version
        keyAttributes = .init(accessControl: .`private`, version: keyVersion)
        keySerializer = .init()
        keyCoder = .init()
        testVectors = try JSONDecoder().decode([MasterKeyTestVector].self, from: privateMasterKeyTestVectorData)
    }

    private func sut() -> PrivateMasterKeyDerivator {
        .init()
    }

    func testGivenVectors_WhenCount_ThenEqual4() {
        XCTAssertEqual(testVectors.count, 4)
    }

    func testGivenSeed_WhenDerivateKey_AndCountKeyBytes_ThenEqual31_Or32() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let extendedKey = try sut.privateMasterKey(seed: seed)
            XCTAssertTrue((31...32).contains(extendedKey.key.count))
        }
    }

    func testGivenSeed_WhenDerivateKey_AndCountChainCodeBytes_ThenEqual32() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let extendedKey = try sut.privateMasterKey(seed: seed)
            XCTAssertEqual(extendedKey.chainCode.count, 32)
        }
    }

    func testGivenVectorSeed_WhenDerivateKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let extendedKey = try sut.privateMasterKey(seed: seed)
            let serializedKey = try keySerializer.serializedKey(extendedKey: extendedKey, attributes: keyAttributes)
            let encodedKey = keyCoder.encode(serializedKey: serializedKey)
            XCTAssertEqual(encodedKey, testVector.base58CheckEncodedKey)
        }
    }
}
