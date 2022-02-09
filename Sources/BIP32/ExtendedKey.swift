import Foundation

public protocol ExtendedKeyable {
    var key: Data { get }
    var chainCode: Data { get }
}

public struct ExtendedKey: ExtendedKeyable {
    public let key: Data
    public let chainCode: Data

    public init(key: Data, chainCode: Data) {
        self.key = key
        self.chainCode = chainCode
    }
}
