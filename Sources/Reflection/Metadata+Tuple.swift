extension Metadata {
    struct Tuple : MetadataType {
        static let kind: Kind? = .tuple
        var pointer: UnsafePointer<Int>
        
        /// The member labels of a tuple are represented as
        /// a single string, where each label is terminated
        /// by a space, even if a member has no label.
        /// For example, the following tuples are represented
        /// by the following strings:
        ///
        /// ```
        /// (foo: T, bar: U, baz: V)
        /// "foo bar baz "
        ///
        /// (T, bar: U, V, baz: W)
        /// " bar  baz "
        /// ```
        var labels: [String?] {
            guard let pointer = UnsafePointer<CChar>(bitPattern: pointer[2]) else { return [] }
            let labelString = String(cString: pointer)
            return labelString.components(separatedBy: " ").map { return $0.isEmpty ? nil : $0 }
        }
    }
}
