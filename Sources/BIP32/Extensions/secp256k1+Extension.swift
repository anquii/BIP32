import Foundation
import secp256k1

extension secp256k1 {
    static func serializedPoint(data: Data, format: ECPointFormat) throws -> Data {
        try secp256k1
            .Signing
            .PrivateKey(
                rawRepresentation: data,
                format: Self.Format(format)
            )
            .publicKey
            .rawRepresentation
    }
}

// MARK: - Helpers
fileprivate extension secp256k1.Format {
    init(_ format: ECPointFormat) {
        switch format {
        case .compressed:
            self = .compressed
        case .uncompressed:
            self = .uncompressed
        }
    }
}
