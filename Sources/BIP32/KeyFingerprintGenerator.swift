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
    public func fingerprint(publicKey: Data) throws -> UInt32 {
        let hash = hash160(data: publicKey)[Self.byteRange]
        guard let fingerprint = UInt32(data: hash) else {
            throw KeyError.invalidKey
        }
        return fingerprint
    }
}

// MARK: - Helpers
fileprivate extension KeyFingerprintGenerator {
    func hash160(data: Data) -> Data {
        RIPEMD160.hash(data: data.sha256())
    }
}
