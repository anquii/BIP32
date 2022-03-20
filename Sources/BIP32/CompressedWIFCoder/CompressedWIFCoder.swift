import Foundation
import Base58Check

public protocol CompressedWIFEncoding {
    func encode(privateKey: Data, version: UInt8) -> String
}

public protocol CompressedWIFDecoding {
    func decode(string: String) throws -> CompressedWIFContainer
}

public struct CompressedWIFCoder {
    private static let byteLength = 34
    private static let byteSuffix = UInt8(1)

    private let base58Check: Base58CheckCoding

    public init(base58Check: Base58CheckCoding = Base58Check()) {
        self.base58Check = base58Check
    }
}

// MARK: - CompressedWIFEncoding
extension CompressedWIFCoder: CompressedWIFEncoding {
    public func encode(privateKey: Data, version: UInt8) -> String {
        let data = Data(version.bytes + privateKey.bytes + Self.byteSuffix.bytes)
        return base58Check.encode(data: data)
    }
}

// MARK: - CompressedWIFDecoding
extension CompressedWIFCoder: CompressedWIFDecoding {
    public func decode(string: String) throws -> CompressedWIFContainer {
        do {
            var data = try base58Check.decode(string: string)
            guard
                data.count == Self.byteLength,
                let version = data.popFirst(),
                let byteSuffix = data.popLast(),
                byteSuffix == Self.byteSuffix
            else {
                throw KeyDecodingError.invalidDecoding
            }
            return CompressedWIFContainer(privateKey: data, version: version)

        } catch {
            throw KeyDecodingError.invalidDecoding
        }
    }
}
