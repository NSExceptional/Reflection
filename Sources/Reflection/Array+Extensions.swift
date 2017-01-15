protocol UTF8Initializable {
    init?(validatingUTF8: UnsafePointer<CChar>)
}

extension String : UTF8Initializable {}

extension Array where Element : UTF8Initializable {

    /// Initializes an Array given a list of inline,
    /// null-terminated strings, which is itself null-terminated.
    init(utf8Strings: UnsafePointer<CChar>) {
        var strings = [Element]()
        var pointer = utf8Strings
        while let string = Element(validatingUTF8: pointer) {
            strings.append(string)
            while pointer.pointee != 0 {
                pointer += 1
            }
            pointer += 1
            guard pointer.pointee != 0 else { break }
        }
        self = strings
    }

}
