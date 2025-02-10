
extension Nonempty.Projected where Content: RandomAccessCollection {
    public var last: Content.Element {
        content.last!
    }
    
    public func separatingLast() -> (prefix: Content.SubSequence, last: Content.Element) {
        return (content[..<content.index(before: content.endIndex)], last)
    }
}
