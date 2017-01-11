extension Metadata {
    struct Tuple : MetadataType {
        static let kind: Kind? = .tuple
        var pointer: UnsafePointer<Int>
        
        var labels: [String?] {
            // Return nil if self->labels == nil
            guard var pointer = UnsafePointer<CChar>(bitPattern: pointer[2]) else { return [] }
            var labels = [String?]()
            var string = ""
            
            // self->labels is a pointer to a string like so:
            // "foo bar baz "
            // where foo, bar, and baz are the labels of the tuple.
            //
            // TODO: make sure string ends in space
            // TODO: could this be done easier by converting the
            //       entire array to a String and splitting on " "?
            while pointer.pointee != 0 {
                // Space means new label
                guard pointer.pointee != 32 else {
                    labels.append(string.isEmpty ? nil : string)
                    string = ""
                    pointer.advance()
                    continue
                }
                
                // Append char
                string.append(String(UnicodeScalar(UInt8(bitPattern: pointer.pointee))))
                pointer.advance()
            }
            
            return labels
        }
    }
}
