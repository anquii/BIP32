import Foundation
import CryptoSwift
import RIPEMD160

public protocol KeyFingerprintGenerating {
    func fingerprint(publicKey: Data) throws -> UInt32
}

public struct KeyFingerprintGenerator {
    private static let byteRange = ...3

    public init() {}
}

// MARK: - KeyFingerprintGenerating
extension KeyFingerprintGenerator: KeyFingerprintGenerating {
    public func fingerprint(publicKey: Data) -> UInt32 {
        .init(
            data: hash160(data: publicKey)[Self.byteRange]
        )!
    }
}

// MARK: - Helpers
fileprivate extension KeyFingerprintGenerator {
    func hash160(data: Data) -> Data {
        RIPEMD160.hash(data: data.sha256())
    }
}
