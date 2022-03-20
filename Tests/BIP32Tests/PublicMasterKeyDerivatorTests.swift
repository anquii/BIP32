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

    func testGivenInvalidPrivateKey_WhenDerivateKey_ThenThrowError() {
        let privateKey = ExtendedKey(
            key: .init(),
            chainCode: .init()
        )
        XCTAssertThrowsError(
            try sut().publicKey(
                privateKey: privateKey
            )
        )
    }

    func testWhenDerivateKey_AndCountKeyBytes_ThenEqual33() throws {
        XCTAssertEqual(
            try publicKey().key.count, 33
        )
    }

    func testWhenDerivateKey_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try publicKey().chainCode.count, 32
        )
    }

    func testGivenVectorSeed_WhenDerivateKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let privateKey = try privateKeyDerivator.privateMasterKey(seed: seed)
            let publicKey = try sut.publicKey(privateKey: privateKey)
            let serializedKey = try keySerializer.serializedKey(extendedKey: publicKey, attributes: keyAttributes)
            let encodedKey = keyCoder.encode(serializedKey: serializedKey)
            XCTAssertEqual(encodedKey, testVector.base58CheckEncodedKey)
        }
    }
}

// MARK: - Helpers
fileprivate extension PublicMasterKeyDerivatorTests {
    func publicKey() throws -> ExtendedKeyable {
        let seed = Data(hex: testVectors.first!.hexEncodedSeed)
        let extendedKey = try privateKeyDerivator.privateMasterKey(seed: seed)
        return try sut().publicKey(privateKey: extendedKey)
    }
}
