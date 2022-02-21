import Foundation
import CryptoSwift

extension FixedWidthInteger {
    init?(data: Data) {
        guard let value = Self(data.toHexString(), radix: 16) else {
            return nil
        }
        self = value
    }

    var bytes: [UInt8] {
        withUnsafeBytes(of: byteSwapped, Array.init)
    }
}
