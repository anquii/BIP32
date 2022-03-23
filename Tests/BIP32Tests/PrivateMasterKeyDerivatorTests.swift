import XCTest
import BIP32

final class PrivateMasterKeyDerivatorTests: XCTestCase {
    private var keyVersion: UInt32!
    private var keyAttributes: MasterKeyAttributes!
    private var keySerializer: KeySerializer!
    private var serializedKeyCoder: SerializedKeyCoder!
    private var testVectors: [MasterKeyTestVector]!

    override func setUpWithError() throws {
        keyVersion = BitcoinVersion(network: .mainnet, keyAccessControl: .`private`).wrappedValue
        keyAttributes = .init(accessControl: .`private`, version: keyVersion)
        keySerializer = .init()
        serializedKeyCoder = .init()
        testVectors = try JSONDecoder().decode([MasterKeyTestVector].self, from: privateMasterKeyTestData)
    }

    private func sut() -> PrivateMasterKeyDerivator {
        .init()
    }

    func testGivenSeed_WhenDerivateKey_AndCountKeyBytes_ThenEqual32() throws {
        let seed = Data(hex: testVectors.first!.hexEncodedSeed)
        let masterKey = try sut().privateMasterKey(seed: seed)
        XCTAssertEqual(masterKey.key.count, 32)
    }

    func testGivenSeed_WhenDerivateKey_AndCountChainCodeBytes_ThenEqual32() throws {
        let seed = Data(hex: testVectors.first!.hexEncodedSeed)
        let masterKey = try sut().privateMasterKey(seed: seed)
        XCTAssertEqual(masterKey.chainCode.count, 32)
    }

    func testGivenVectorSeed_WhenDerivateKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            let masterKey = try sut.privateMasterKey(seed: seed)
            let serializedKey = try keySerializer.serializedKey(extendedKey: masterKey, attributes: keyAttributes)
            let encodedKey = serializedKeyCoder.encode(serializedKey: serializedKey)
            XCTAssertEqual(encodedKey, testVector.base58CheckEncodedKey)
        }
    }
}
