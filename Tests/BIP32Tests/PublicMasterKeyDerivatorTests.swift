import XCTest
import CryptoSwift
@testable import BIP32

final class PublicMasterKeyDerivatorTests: XCTestCase {
    private var privateKeyDerivator: PrivateMasterKeyDerivator!
    private var keyVersion: UInt32!
    private var keyAttributes: MasterKeyAttributes!
    private var keySerializer: KeySerializer!
    private var keyCoder: KeyCoder!
    private var testVectors: [MasterKeyTestVector]!

    override func setUpWithError() throws {
        privateKeyDerivator = .init()
        keyVersion = BitcoinVersionContainer(network: .mainnet, keyAccessControl: .`public`).version
        keyAttributes = .init(accessControl: .`public`, version: keyVersion)
        keySerializer = .init()
        keyCoder = .init()
        testVectors = try JSONDecoder().decode([MasterKeyTestVector].self, from: publicMasterKeyTestVectorData)
    }

    private func sut() -> PublicMasterKeyDerivator {
        .init()
    }

    func testGivenVectors_WhenCount_ThenEqual4() {
        XCTAssertEqual(testVectors.count, 4)
    }

    func testGivenInvalidPrivateKey_AndCompressedPointFormat_WhenDerivateKey_ThenThrowError() {
        let privateKey = ExtendedKey(
            key: .init(),
            chainCode: .init()
        )
        XCTAssertThrowsError(
            try sut().publicKey(
                privateKey: privateKey,
                pointFormat: .compressed
            )
        )
    }

    func testGivenPrivateKey_AndCompressedPointFormat_WhenDerivateKey_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try publicKey(pointFormat: .compressed)
        )
    }

    func testGivenPrivateKey_AndUncompressedPointFormat_WhenDerivateKey_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try publicKey(pointFormat: .uncompressed)
        )
    }

    func testGivenUncompressedPointFormat_WhenDerivateKey_AndCountKeyBytes_ThenEqual65() throws {
        XCTAssertEqual(
            try publicKey(pointFormat: .uncompressed).key.count, 65
        )
    }

    func testGivenUncompressedPointFormat_WhenDerivateKey_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try publicKey(pointFormat: .uncompressed).chainCode.count, 32
        )
    }

    func testGivenCompressedPointFormat_WhenDerivateKey_AndCountKeyBytes_ThenEqual33() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let privateKey = try privateKeyDerivator.privateMasterKey(seed: seed)
            let publicKey = try sut.publicKey(privateKey: privateKey, pointFormat: .compressed)
            XCTAssertEqual(publicKey.key.count, 33)
        }
    }

    func testGivenCompressedPointFormat_WhenDerivateKey_AndCountChainCodeBytes_ThenEqual32() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let privateKey = try privateKeyDerivator.privateMasterKey(seed: seed)
            let publicKey = try sut.publicKey(privateKey: privateKey, pointFormat: .compressed)
            XCTAssertEqual(publicKey.chainCode.count, 32)
        }
    }

    func testGivenVectorSeed_WhenDerivateKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let privateKey = try privateKeyDerivator.privateMasterKey(seed: seed)
            let publicKey = try sut.publicKey(privateKey: privateKey, pointFormat: .compressed)
            let serializedKey = try keySerializer.serializedKey(extendedKey: publicKey, attributes: keyAttributes)
            let encodedKey = keyCoder.encode(serializedKey: serializedKey)
            XCTAssertEqual(encodedKey, testVector.base58CheckEncodedKey)
        }
    }
}

// MARK: - Helpers
fileprivate extension PublicMasterKeyDerivatorTests {
    func publicKey(pointFormat: ECPointFormat) throws -> ExtendedKeyable {
        let seed = Data(hex: testVectors.first!.hexEncodedSeed)
        let extendedKey = try privateKeyDerivator.privateMasterKey(seed: seed)
        return try sut().publicKey(privateKey: extendedKey, pointFormat: pointFormat)
    }
}
