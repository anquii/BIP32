import Foundation
import XCTest
import BIP32

final class PublicChildKeyDerivatorTests: XCTestCase {
    private let privateMasterKeyDerivator = PrivateMasterKeyDerivator()
    private let publicMasterKeyDerivator = PublicMasterKeyDerivator()
    private let privateChildKeyDerivator = PrivateChildKeyDerivator()
    private let keyVersion = BitcoinVersion(network: .mainnet, keyAccessControl: .`public`).wrappedValue
    private let keyFingerprintDerivator = KeyFingerprintDerivator()
    private let keyIndexHardener = KeyIndexHardener()
    private let keySerializer = KeySerializer()
    private let serializedKeyCoder = SerializedKeyCoder()
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [KeyTestVector]!

    override func setUpWithError() throws {
        testVectors = try jsonDecoder.decode([KeyTestVector].self, from: keyTestData)
    }

    private func sut() -> PublicChildKeyDerivator {
        .init()
    }

    func testGivenPrivateChildKey_WhenDerivatePublicChildKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            var privateParentKey = try privateMasterKeyDerivator.privateKey(seed: seed)
            var publicParentKey = try publicMasterKeyDerivator.publicKey(privateKey: privateParentKey)

            for derivatedKey in testVector.derivatedKeys {
                guard derivatedKey.depth > 0 else {
                    continue
                }
                let childKeyIndex = derivatedKey.isIndexHardened
                    ? try keyIndexHardener.hardenedIndex(normalIndex: derivatedKey.index)
                    : derivatedKey.index
                let privateChildKey = try privateChildKeyDerivator.privateKey(
                    privateParentKey: privateParentKey,
                    index: childKeyIndex
                )
                let publicChildKey = try sut.publicKey(privateKey: privateChildKey)
                XCTAssertEqual(publicChildKey.key.count, 33)
                XCTAssertEqual(publicChildKey.chainCode.count, 32)

                let parentKeyFingerprint = keyFingerprintDerivator.fingerprint(publicKey: publicParentKey.key)
                let childKeyAttributes = ChildKeyAttributes(
                    accessControl: .`public`,
                    version: keyVersion,
                    depth: derivatedKey.depth,
                    parentKeyFingerprint: parentKeyFingerprint,
                    index: childKeyIndex
                )
                let serializedChildKey = try keySerializer.serializedKey(
                    extendedKey: publicChildKey,
                    attributes: childKeyAttributes
                )
                let encodedChildKey = serializedKeyCoder.encode(serializedKey: serializedChildKey)
                XCTAssertEqual(encodedChildKey, derivatedKey.base58CheckEncodedPublicKey)
                privateParentKey = privateChildKey
                publicParentKey = publicChildKey
            }
        }
    }

    func testGivenPublicParentKey_WhenDerivatePublicChildKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            var privateParentKey = try privateMasterKeyDerivator.privateKey(seed: seed)
            var publicParentKey = try publicMasterKeyDerivator.publicKey(privateKey: privateParentKey)

            for derivatedKey in testVector.derivatedKeys {
                guard derivatedKey.depth > 0 else {
                    continue
                }
                guard !derivatedKey.isIndexHardened else {
                    let childKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: derivatedKey.index)
                    let privateChildKey = try privateChildKeyDerivator.privateKey(
                        privateParentKey: privateParentKey,
                        index: childKeyIndex
                    )
                    privateParentKey = privateChildKey
                    publicParentKey = try sut.publicKey(privateKey: privateChildKey)
                    continue
                }
                let publicChildKey = try sut.publicKey(publicParentKey: publicParentKey, index: derivatedKey.index)
                XCTAssertEqual(publicChildKey.key.count, 33)
                XCTAssertEqual(publicChildKey.chainCode.count, 32)

                let parentKeyFingerprint = keyFingerprintDerivator.fingerprint(publicKey: publicParentKey.key)
                let childKeyAttributes = ChildKeyAttributes(
                    accessControl: .`public`,
                    version: keyVersion,
                    depth: derivatedKey.depth,
                    parentKeyFingerprint: parentKeyFingerprint,
                    index: derivatedKey.index
                )
                let serializedChildKey = try keySerializer.serializedKey(
                    extendedKey: publicChildKey,
                    attributes: childKeyAttributes
                )
                let encodedChildKey = serializedKeyCoder.encode(serializedKey: serializedChildKey)
                XCTAssertEqual(encodedChildKey, derivatedKey.base58CheckEncodedPublicKey)
                privateParentKey = try privateChildKeyDerivator.privateKey(
                    privateParentKey: privateParentKey,
                    index: derivatedKey.index
                )
                publicParentKey = publicChildKey
            }
        }
    }
}
