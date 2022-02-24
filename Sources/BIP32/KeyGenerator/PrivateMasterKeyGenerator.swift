import Foundation
import CryptoSwift

public protocol PrivateMasterKeyGenerating {
    func privateMasterKey(seed: Data) throws -> ExtendedKeyable
}

public struct PrivateMasterKeyGenerator {
    private static let hmacSHA512Key = "Bitcoin seed"

    public init() {}
}

// MARK: - PrivateMasterKeyGenerating
extension PrivateMasterKeyGenerator: PrivateMasterKeyGenerating {
    public func privateMasterKey(seed: Data) throws -> ExtendedKeyable {
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
