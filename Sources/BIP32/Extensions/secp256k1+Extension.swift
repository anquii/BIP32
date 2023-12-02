import Foundation
import secp256k1

extension secp256k1 {
    static func serializedPoint(data: Data) throws -> Data {
        try secp256k1
            .Signing
            .PrivateKey(
                dataRepresentation: data,
                format: .compressed
            )
            .publicKey
            .dataRepresentation
    }
}
