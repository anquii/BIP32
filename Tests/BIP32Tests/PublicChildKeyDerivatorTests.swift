import XCTest
@testable import BIP32

final class PublicChildKeyDerivatorTests: XCTestCase {
    private var privateMasterKeyDerivator: PrivateMasterKeyDerivator!
    private var publicMasterKeyDerivator: PublicMasterKeyDerivator!
    private var privateChildKeyDerivator: PrivateChildKeyDerivator!
    private var keyVersion: UInt32!
    private var keyFingerprintDerivator: KeyFingerprintDerivator!
    private var keyIndexHardener: KeyIndexHardener!
    private var keySerializer: KeySerializer!
    private var keyCoder: KeyCoder!
    private var testVectors: [KeyTestVector]!

    override func setUpWithError() throws {
        privateMasterKeyDerivator = .init()
        publicMasterKeyDerivator = .init()
        privateChildKeyDerivator = .init()
        keyVersion = BitcoinVersionContainer(network: .mainnet, keyAccessControl: .`public`).version
        keyFingerprintDerivator = .init()
        keyIndexHardener = .init()
        keySerializer = .init()
        keyCoder = .init()
        testVectors = try JSONDecoder().decode([KeyTestVector].self, from: keyTestVectorData)
    }

    private func sut() -> PublicChildKeyDerivator {
        .init()
    }

    func testGivenPrivateChildKey_WhenDerivatePublicChildKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let seed = Data(hex: testVector.hexEncodedSeed)
            var privateParentKey = try privateMasterKeyDerivator.privateMasterKey(seed: seed)
            var publicParentKey = try publicMasterKeyDerivator.publicKey(privateKey: privateParentKey)

            for derivatedKey in testVector.derivatedKeys {
                guard derivatedKey.depth > 0 else {
                    continue
                }
                let childKeyIndex = derivatedKey.isIndexHardened
                    ? try keyIndexHardener.hardenedIndex(normalIndex: derivatedKey.index)
                    : derivatedKey.index
                let privateChildKey = try privateChildKeyDerivator.privateChildKey(
                    privateParentKey: privateParentKey,
                    index: childKeyIndex
                )
                let publicChildKey = try sut.publicKey(privateKey: privateChildKey)
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
                let encodedChildKey = keyCoder.encode(serializedKey: serializedChildKey)
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
            var privateParentKey = try privateMasterKeyDerivator.privateMasterKey(seed: seed)
            var publicParentKey = try publicMasterKeyDerivator.publicKey(privateKey: privateParentKey)

            for derivatedKey in testVector.derivatedKeys {
                guard derivatedKey.depth > 0 else {
                    continue
                }
                guard !derivatedKey.isIndexHardened else {
                    let childKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: derivatedKey.index)
                    let privateChildKey = try privateChildKeyDerivator.privateChildKey(
                        privateParentKey: privateParentKey,
                        index: childKeyIndex
                    )
                    privateParentKey = privateChildKey
                    publicParentKey = try sut.publicKey(privateKey: privateChildKey)
                    continue
                }
                let publicChildKey = try sut.publicKey(publicParentKey: publicParentKey, index: derivatedKey.index)
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
                let encodedChildKey = keyCoder.encode(serializedKey: serializedChildKey)
                XCTAssertEqual(encodedChildKey, derivatedKey.base58CheckEncodedPublicKey)
                privateParentKey = try privateChildKeyDerivator.privateChildKey(
                    privateParentKey: privateParentKey,
                    index: derivatedKey.index
                )
                publicParentKey = publicChildKey
            }
        }
    }
}
