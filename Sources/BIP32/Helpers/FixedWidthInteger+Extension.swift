import Foundation
import CryptoSwift

extension FixedWidthInteger {
    init?(data: Data) {
        guard let value = Self(data.toHexString(), radix: 16) else {
            return nil
        }
        self = value
    }

    func bytes(order: ByteOrder = .`default`) -> [UInt8] {
        let representation: Self

        switch order {
        case .`default`:
            representation = self
        case .bigEndian:
            representation = bigEndian
        case .littleEndian:
            representation = littleEndian
        case .byteSwapped:
            representation = byteSwapped
        }

        return withUnsafeBytes(of: representation, Array.init)
    }
}
