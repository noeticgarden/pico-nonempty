
extension Nonempty.Projected where Content.Element: Comparable {
    /// Returns the maximum element in this collection, according to the order of elements produced by their [`Comparable`](https://developer.apple.com/documentation/swift/comparable) conformance.
    ///
    /// Unline the equivalent standard library method, this method is guaranteed to return an element.
    public func max() -> Content.Element {
        return content.max()!
    }
    
    /// Returns the minimum element in this collection, according to the order of elements produced by their [`Comparable`](https://developer.apple.com/documentation/swift/comparable) conformance.
    ///
    /// Unline the equivalent standard library method, this method is guaranteed to return an element.
    public func min() -> Content.Element {
        return content.min()!
    }
}
