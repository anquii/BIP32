import Foundation
import secp256k1

extension secp256k1 {
    static func serializedPoint(data: Data) throws -> Data {
        try secp256k1
            .Signing
            .PrivateKey(
                rawRepresentation: data,
                format: .compressed
            )
            .publicKey
            .rawRepresentation
    }
}
