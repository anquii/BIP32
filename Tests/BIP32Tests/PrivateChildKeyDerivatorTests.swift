import XCTest
import BIP32

final class PrivateChildKeyDerivatorTests: XCTestCase {
    private let privateMasterKeyDerivator = PrivateMasterKeyDerivator()
    private let publicMasterKeyDerivator = PublicMasterKeyDerivator()
    private let publicChildKeyDerivator = PublicChildKeyDerivator()
    private let keyVersion = BitcoinVersion(network: .mainnet, keyAccessControl: .`private`).wrappedValue
    private let keyFingerprintDerivator = KeyFingerprintDerivator()
    private let keyIndexHardener = KeyIndexHardener()
    private let keySerializer = KeySerializer()
    private let serializedKeyCoder = SerializedKeyCoder()
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [KeyTestVector]!

    override func setUpWithError() throws {
        testVectors = try jsonDecoder.decode([KeyTestVector].self, from: keyTestData)
    }

    private func sut() -> PrivateChildKeyDerivator {
        .init()
    }

    func testGivenPrivateParentKey_WhenDerivatePrivateChildKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            var privateParentKey = try privateMasterKeyDerivator.privateMasterKey(seed: seed)

            for derivatedKey in testVector.derivatedKeys {
                guard derivatedKey.depth > 0 else {
                    continue
                }
                let publicParentKey = try publicChildKeyDerivator.publicKey(privateKey: privateParentKey)
                let childKeyIndex = derivatedKey.isIndexHardened
                    ? try keyIndexHardener.hardenedIndex(normalIndex: derivatedKey.index)
                    : derivatedKey.index
                let privateChildKey = try sut.privateChildKey(
                    privateParentKey: privateParentKey,
                    index: childKeyIndex
                )
                XCTAssertEqual(privateChildKey.key.count, 32)
                XCTAssertEqual(privateChildKey.chainCode.count, 32)

                let parentKeyFingerprint = keyFingerprintDerivator.fingerprint(publicKey: publicParentKey.key)
                let privateChildKeyAttributes = ChildKeyAttributes(
                    accessControl: .`private`,
                    version: keyVersion,
                    depth: derivatedKey.depth,
                    parentKeyFingerprint: parentKeyFingerprint,
                    index: childKeyIndex
                )
                let serializedChildKey = try keySerializer.serializedKey(
                    extendedKey: privateChildKey,
                    attributes: privateChildKeyAttributes
                )
                let encodedChildKey = serializedKeyCoder.encode(serializedKey: serializedChildKey)
                XCTAssertEqual(encodedChildKey, derivatedKey.base58CheckEncodedPrivateKey)
                privateParentKey = privateChildKey
            }
        }
    }
}
