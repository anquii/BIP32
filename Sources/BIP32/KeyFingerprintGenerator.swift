import Foundation

public protocol KeyFingerprintGenerating {
    func fingerprint() -> Data
}

public struct KeyFingerprintGenerator {
    public init() {}
}

// MARK: - KeyFingerprintGenerating
extension KeyFingerprintGenerator: KeyFingerprintGenerating {
    public func fingerprint() -> Data {
        fatalError()
    }
}
