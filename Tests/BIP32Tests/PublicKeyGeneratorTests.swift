import XCTest
@testable import BIP32

final class PublicKeyGeneratorTests: XCTestCase {
    private func sut() -> PublicKeyGenerator {
        .init()
    }

    func testGivenInvalidPrivateKey_AndCompressedPointFormat_WhenGenerate_ThenThrowError() {
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

    func testGivenExtendedKey_AndCompressedPointFormat_WhenGenerate_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try publicKey()
        )
    }

    func testGivenUncompressedPointFormat_WhenGenerate_AndCountKeyBytes_ThenEqual65() throws {
        XCTAssertEqual(
            try publicKey(pointFormat: .uncompressed).key.count, 65
        )
    }

    func testGivenUncompressedPointFormat_WhenGenerate_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try publicKey(pointFormat: .uncompressed).chainCode.count, 32
        )
    }

    func testGivenCompressedPointFormat_WhenGenerate_AndCountKeyBytes_ThenEqual33() throws {
        XCTAssertEqual(
            try publicKey(pointFormat: .compressed).key.count, 33
        )
    }

    func testGivenCompressedPointFormat_WhenGenerate_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try publicKey(pointFormat: .compressed).chainCode.count, 32
        )
    }
}

// MARK: - Helpers
fileprivate extension PublicKeyGeneratorTests {
    func publicKey(pointFormat: ECPointFormat = .compressed) throws -> ExtendedKeyable {
        let privateKey = try PrivateMasterKeyGenerator().privateMasterKey(seed: seedTestData)
        return try sut().publicKey(privateKey: privateKey, pointFormat: pointFormat)
    }
}
