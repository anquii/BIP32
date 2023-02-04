import Foundation
import XCTest
import BIP32

final class PrivateMasterKeyDerivatorTests: XCTestCase {
    private let keyVersion = KeyVersion(network: .mainnet, keyAccessControl: .`private`).wrappedValue
    private var keyAttributes: MasterKeyAttributes!
    private let keySerializer = KeySerializer()
    private let serializedKeyCoder = SerializedKeyCoder()
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [MasterKeyTestVector]!

    override func setUpWithError() throws {
        keyAttributes = .init(accessControl: .`private`, version: keyVersion)
        testVectors = try jsonDecoder.decode([MasterKeyTestVector].self, from: privateMasterKeyTestData)
    }

    private func sut() -> PrivateMasterKeyDerivator {
        .init()
    }

    func testGivenSeed_WhenDerivateKey_AndCountKeyBytes_ThenEqual32() throws {
        let seed = Data(hex: testVectors.first!.hexEncodedSeed)
        let masterKey = try sut().privateKey(seed: seed)
        XCTAssertEqual(masterKey.key.count, 32)
    }

    func testGivenSeed_WhenDerivateKey_AndCountChainCodeBytes_ThenEqual32() throws {
        let seed = Data(hex: testVectors.first!.hexEncodedSeed)
        let masterKey = try sut().privateKey(seed: seed)
        XCTAssertEqual(masterKey.chainCode.count, 32)
    }

    func testGivenVectorSeed_WhenDerivateKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let masterKey = try sut.privateKey(seed: seed)
            let serializedKey = try keySerializer.serializedKey(extendedKey: masterKey, attributes: keyAttributes)
            let encodedKey = serializedKeyCoder.encode(serializedKey: serializedKey)
            XCTAssertEqual(encodedKey, testVector.base58CheckEncodedKey)
        }
    }
}
