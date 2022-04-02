import Foundation
import XCTest
@testable import BIP32

final class PublicMasterKeyDerivatorTests: XCTestCase {
    private let privateKeyDerivator = PrivateMasterKeyDerivator()
    private let keyVersion = BitcoinVersion(network: .mainnet, keyAccessControl: .`public`).wrappedValue
    private var keyAttributes: MasterKeyAttributes!
    private let keySerializer = KeySerializer()
    private let serializedKeyCoder = SerializedKeyCoder()
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [MasterKeyTestVector]!

    override func setUpWithError() throws {
        keyAttributes = .init(accessControl: .`public`, version: keyVersion)
        testVectors = try jsonDecoder.decode([MasterKeyTestVector].self, from: publicMasterKeyTestData)
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
            try sut().publicKey(privateKey: privateKey)
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
            let privateKey = try privateKeyDerivator.privateKey(seed: seed)
            let publicKey = try sut.publicKey(privateKey: privateKey)
            let serializedKey = try keySerializer.serializedKey(extendedKey: publicKey, attributes: keyAttributes)
            let encodedKey = serializedKeyCoder.encode(serializedKey: serializedKey)
            XCTAssertEqual(encodedKey, testVector.base58CheckEncodedKey)
        }
    }
}

// MARK: - Helpers
fileprivate extension PublicMasterKeyDerivatorTests {
    func publicKey() throws -> ExtendedKeyable {
        let seed = Data(hex: testVectors.first!.hexEncodedSeed)
        let extendedKey = try privateKeyDerivator.privateKey(seed: seed)
        return try sut().publicKey(privateKey: extendedKey)
    }
}
