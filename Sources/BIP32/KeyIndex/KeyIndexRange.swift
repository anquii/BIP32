struct KeyIndexRange {
    static let normal: ClosedRange<UInt32> = 0x0...0x7FFFFFFF
    static let hardened: ClosedRange<UInt32> = 0x80000000...0xFFFFFFFF

    private init() {}
}
