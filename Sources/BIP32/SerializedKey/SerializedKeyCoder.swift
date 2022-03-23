import Base58Check

public protocol SerializedKeyEncoding {
    func encode(serializedKey: SerializedKeyable) -> String
}

public protocol SerializedKeyDecoding {
    func decode(string: String) throws -> SerializedKeyable
}

public typealias SerializedKeyCoding = SerializedKeyEncoding & SerializedKeyDecoding

public struct SerializedKeyCoder {
    private let base58Check: Base58CheckCoding

    public init(base58Check: Base58CheckCoding = Base58Check()) {
        self.base58Check = base58Check
    }
}

// MARK: - SerializedKeyEncoding
extension SerializedKeyCoder: SerializedKeyEncoding {
    public func encode(serializedKey: SerializedKeyable) -> String {
        base58Check.encode(data: serializedKey.data)
    }
}

// MARK: - SerializedKeyDecoding
extension SerializedKeyCoder: SerializedKeyDecoding {
    public func decode(string: String) throws -> SerializedKeyable {
        do {
            let decodedData = try base58Check.decode(string: string)
            return try SerializedKey(data: decodedData)
        } catch {
            throw KeyDecodingError.invalidDecoding
        }
    }
}
