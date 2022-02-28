import secp256k1

extension secp256k1.Format {
    init(_ format: ECPointFormat) {
        switch format {
        case .compressed:
            self = .compressed
        case .uncompressed:
            self = .uncompressed
        }
    }
}
