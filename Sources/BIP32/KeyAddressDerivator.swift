import Foundation
import CryptoSwift
import RIPEMD160
import Base58Check

public protocol KeyAddressDerivating {
    func address(publicKey: Data, version: UInt8) -> String
}

public struct KeyAddressDerivator {
    private let base58Check: Base58CheckEncoding

    public init(base58Check: Base58CheckEncoding = Base58Check()) {
        self.base58Check = base58Check
    }
}

// MARK: - KeyAddressDerivating
extension KeyAddressDerivator: KeyAddressDerivating {
    public func address(publicKey: Data, version: UInt8) -> String {
        let hash160 = RIPEMD160.hash(data: publicKey.sha256())
        let data = Data(version.bytes + hash160.bytes)
        return base58Check.encode(data: data)
    }
}
