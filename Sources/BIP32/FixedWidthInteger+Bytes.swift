extension FixedWidthInteger {
    var bytes: [UInt8] {
        withUnsafeBytes(of: byteSwapped, Array.init)
    }
}
