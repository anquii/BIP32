import Foundation
import CryptoSwift

public protocol MasterKeyGenerating {
    func masterKey(seed: Data) throws -> ExtendedKeyable
}

public struct MasterKeyGenerator {
    private static let hmacSHA512Key = "Bitcoin seed"

    public init() {}
}

// MARK: - MasterKeyGenerating
extension MasterKeyGenerator: MasterKeyGenerating {
    public func masterKey(seed: Data) throws -> ExtendedKeyable {
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
fileprivate extension MasterKeyGenerator {
    struct HMACSHA512ByteRange {
        private init() {}

        static let left = ..<32
        static let right = 32...
    }
}
