
extension Nonempty.Projected where Content: RangeReplaceableCollection {
    public mutating func append(_ element: Content.Element) {
        content.content.append(element)
        precondition(!content.isEmpty)
    }
    
    public mutating func append<S>(contentsOf newElements: S) where S : Sequence, Content.Element == S.Element {
        content.content.append(contentsOf: newElements)
        precondition(!content.isEmpty)
    }
    
    public mutating func insert(_ newElement: Content.Element, at i: Content.Index) {
        content.content.insert(newElement, at: i)
        precondition(!content.isEmpty)
    }
    
    public mutating func insert<S>(contentsOf newElements: S, at i: Content.Index) where S : Collection, Content.Element == S.Element {
        content.content.insert(contentsOf: newElements, at: i)
        precondition(!content.isEmpty)
    }
}
