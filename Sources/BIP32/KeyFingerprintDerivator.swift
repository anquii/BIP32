import Foundation
import CryptoSwift
import RIPEMD160

public protocol KeyFingerprintDerivating {
    func fingerprint(publicKey: Data) -> UInt32
    func fingerprintAndHash160(publicKey: Data) -> (fingerprint: UInt32, hash160: Data)
}

public struct KeyFingerprintDerivator {
    private static let byteRange = ...3

    public init() {}
}

// MARK: - KeyFingerprintDerivating
extension KeyFingerprintDerivator: KeyFingerprintDerivating {
    public func fingerprint(publicKey: Data) -> UInt32 {
        fingerprintAndHash160(publicKey: publicKey).fingerprint
    }

    public func fingerprintAndHash160(publicKey: Data) -> (fingerprint: UInt32, hash160: Data) {
        let hash160 = RIPEMD160.hash(data: publicKey.sha256())
        let fingerprint = UInt32(data: hash160[Self.byteRange])!
        return (fingerprint, hash160)
    }
}
