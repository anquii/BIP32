import Foundation
import CryptoSwift
import RIPEMD160

public protocol KeyFingerprintDerivating {
    func fingerprint(publicKey: Data) throws -> UInt32
}

public struct KeyFingerprintDerivator {
    private static let byteRange = ...3

    public init() {}
}

// MARK: - KeyFingerprintDerivating
extension KeyFingerprintDerivator: KeyFingerprintDerivating {
    public func fingerprint(publicKey: Data) -> UInt32 {
        .init(
            data: hash160(data: publicKey)[Self.byteRange]
        )!
    }
}

// MARK: - Helpers
fileprivate extension KeyFingerprintDerivator {
    func hash160(data: Data) -> Data {
        RIPEMD160.hash(data: data.sha256())
    }
}
