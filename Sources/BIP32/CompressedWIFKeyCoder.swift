import Foundation
import Base58Check

public protocol CompressedWIFKeyEncoding {
    func encode(privateKey: Data, version: UInt8) -> String
}

public protocol CompressedWIFKeyDecoding {
    func decode(string: String) throws -> (privateKey: Data, version: UInt8)
}

public typealias CompressedWIFKeyCoding = CompressedWIFKeyEncoding & CompressedWIFKeyDecoding

public struct CompressedWIFKeyCoder {
    private static let keyLength = 32
    private static let byteLength = 34
    private static let byteSuffix = UInt8(1)

    private let base58Check: Base58CheckCoding

    public init(base58Check: Base58CheckCoding = Base58Check()) {
        self.base58Check = base58Check
    }
}

// MARK: - CompressedWIFKeyEncoding
extension CompressedWIFKeyCoder: CompressedWIFKeyEncoding {
    public func encode(privateKey: Data, version: UInt8) -> String {
        let data = Data(version.bytes + privateKey.suffix(Self.keyLength).bytes + Self.byteSuffix.bytes)
        return base58Check.encode(data: data)
    }
}

// MARK: - CompressedWIFKeyDecoding
extension CompressedWIFKeyCoder: CompressedWIFKeyDecoding {
    public func decode(string: String) throws -> (privateKey: Data, version: UInt8) {
        do {
            var data = try base58Check.decode(string: string)
            guard
                data.count == Self.byteLength,
                let version = data.popFirst(),
                let byteSuffix = data.popLast(),
                byteSuffix == Self.byteSuffix
            else {
                throw KeyCoderError.invalidDecoding
            }
            return (data, version)

        } catch {
            throw KeyCoderError.invalidDecoding
        }
    }
}
