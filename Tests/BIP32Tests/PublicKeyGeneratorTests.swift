import XCTest
@testable import BIP32

final class PublicKeyGeneratorTests: XCTestCase {
    private func sut() -> PublicKeyGenerator {
        .init()
    }

    func testGivenInvalidExtendedKey_AndCompressionFormat_WhenGenerate_ThenThrowError() {
        let invalidExtendedKey = ExtendedKey(
            key: .init(),
            chainCode: .init()
        )
        XCTAssertThrowsError(
            try sut().publicKey(
                extendedPrivateKey: invalidExtendedKey,
                format: .compressed
            )
        )
    }

    func testGivenExtendedKey_AndCompressionFormat_WhenGenerate_ThenNoErrorThrown() {
        XCTAssertNoThrow(
            try publicKey()
        )
    }

    func testGivenUncompressedFormat_WhenGenerate_AndCountKeyBytes_ThenEqual65() throws {
        XCTAssertEqual(
            try publicKey(format: .uncompressed).key.count, 65
        )
    }

    func testGivenUncompressedFormat_WhenGenerate_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try publicKey(format: .uncompressed).chainCode.count, 32
        )
    }

    func testGivenCompressedFormat_WhenGenerate_AndCountKeyBytes_ThenEqual33() throws {
        XCTAssertEqual(
            try publicKey(format: .compressed).key.count, 33
        )
    }

    func testGivenCompressedFormat_WhenGenerate_AndCountChainCodeBytes_ThenEqual32() throws {
        XCTAssertEqual(
            try publicKey(format: .compressed).chainCode.count, 32
        )
    }
}

// MARK: - Helpers
fileprivate extension PublicKeyGeneratorTests {
    func publicKey(format: PublicKeyFormat = .compressed) throws -> ExtendedKeyable {
        let extendedPrivateKey = try MasterPrivateKeyGenerator().masterPrivateKey(seed: seedTestData)
        return try sut().publicKey(extendedPrivateKey: extendedPrivateKey, format: format)
    }
}
