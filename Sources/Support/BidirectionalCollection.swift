
extension Nonempty: BidirectionalCollection where Content: BidirectionalCollection {
    public func index(before i: Content.Index) -> Content.Index {
        content.index(before: i)
    }
    
    public func formIndex(before i: inout Content.Index) {
        content.formIndex(before: &i)
    }
}
