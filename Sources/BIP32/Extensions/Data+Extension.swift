import Foundation
import CryptoSwift

extension Data {
    init(hex: String) {
        self.init(Array<UInt8>(hex: hex))
    }

    var bytes: Array<UInt8> {
        Array(self)
    }

    func toHexString() -> String {
        bytes.toHexString()
    }
}
