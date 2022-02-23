public protocol KeyEncoding {
    func encode(serializedKey: SerializedKeyable) -> String
}

public protocol KeyDecoding {
    func decode(string: String) throws -> SerializedKeyable
}

public typealias KeyCoding = KeyEncoding & KeyDecoding
