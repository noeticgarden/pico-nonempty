
extension Nonempty: Collection {
    public var indices: Content.Indices {
        content.indices
    }
    
    public var isEmpty: Bool {
        false
    }
    
    public var count: Int {
        content.count
    }
    
    public func index(after i: Content.Index) -> Content.Index {
        content.index(after: i)
    }
    
    public func formIndex(after i: inout Content.Index) {
        content.formIndex(after: &i)
    }
    
    public func index(_ i: Content.Index, offsetBy distance: Int) -> Content.Index {
        content.index(i, offsetBy: distance)
    }
    
    public func index(_ i: Content.Index, offsetBy distance: Int, limitedBy limit: Content.Index) -> Content.Index? {
        content.index(i, offsetBy: distance, limitedBy: limit)
    }
    
    public func distance(from start: Content.Index, to end: Content.Index) -> Int {
        content.distance(from: start, to: end)
    }
    
    public var startIndex: Content.Index {
        content.startIndex
    }
    
    public var endIndex: Content.Index {
        content.endIndex
    }
    
    public typealias Index = Content.Index
    public typealias Iterator = Content.Iterator
    
    public func makeIterator() -> Content.Iterator {
        content.makeIterator()
    }
    
    public subscript(position: Content.Index) -> Content.Element {
        content[position]
    }
    
    public subscript(bounds: Range<Content.Index>) -> Content.SubSequence {
        content[bounds]
    }
}
