import Foundation
import CryptoSwift

public protocol MasterPrivateKeyGenerating {
    func masterPrivateKey(seed: Data) throws -> ExtendedKeyable
}

public struct MasterPrivateKeyGenerator {
    private static let hmacSHA512Key = "Bitcoin seed"

    public init() {}
}

// MARK: - MasterPrivateKeyGenerating
extension MasterPrivateKeyGenerator: MasterPrivateKeyGenerating {
    public func masterPrivateKey(seed: Data) throws -> ExtendedKeyable {
        let hmacSHA512 = HMAC(
            key: Self.hmacSHA512Key.bytes,
            variant: .sha2(.sha512)
        )
        do {
            let hmacSHA512Bytes = try hmacSHA512.authenticate(seed.bytes)
            let key = hmacSHA512Bytes[HMACSHA512ByteRange.left]
            let chainCode = hmacSHA512Bytes[HMACSHA512ByteRange.right]

            return ExtendedKey(
                key: Data(key),
                chainCode: Data(chainCode)
            )
        } catch {
            throw KeyError.invalidKey
        }
    }
}

// MARK: - Helpers
fileprivate extension MasterPrivateKeyGenerator {
    struct HMACSHA512ByteRange {
        static let left = ..<32
        static let right = 32...

        private init() {}
    }
}
