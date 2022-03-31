import Foundation
import CryptoSwift
import RIPEMD160

public protocol KeyFingerprintDerivating {
    func fingerprint(publicKey: Data) -> UInt32
}

public struct KeyFingerprintDerivator {
    private static let byteRange = ...3

    public init() {}
}

// MARK: - KeyFingerprintDerivating
extension KeyFingerprintDerivator: KeyFingerprintDerivating {
    public func fingerprint(publicKey: Data) -> UInt32 {
        let hash160 = RIPEMD160.hash(data: publicKey.sha256())
        let data = hash160[Self.byteRange]
        return .init(data: data)!
    }
}
