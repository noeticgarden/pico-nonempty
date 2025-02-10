
extension Nonempty.Projected where Content: RandomAccessCollection {
    /// Returns the last element in this collection.
    ///
    /// Unline the equivalent standard library property, this method is guaranteed to return an property.
    public var last: Content.Element {
        content.last!
    }
    
    /// Returns elements of the collection, separating the last element from a a subsequence of all preceding element.
    ///
    /// While the receiver is nonempty, the subsequence may be empty if there is a single element in the receiver.
    public func separatingLast() -> (prefix: Content.SubSequence, last: Content.Element) {
        return (content[..<content.index(before: content.endIndex)], last)
    }
}
