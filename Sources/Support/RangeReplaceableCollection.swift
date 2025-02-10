
extension Nonempty.Projected where Content: RangeReplaceableCollection {
    /// Appends an element to the end of the collection.
    ///
    /// This method edits the `Nonempty` receiver and maintains its guarantee that the underlying contents are nonempty.
    ///
    /// > Warning: If the underlying collection mutates to become empty after appending the element, this method will raise a fatal error.
    public mutating func append(_ element: Content.Element) {
        content._content.append(element)
        precondition(!content.isEmpty)
    }
    
    /// Appends a sequence of elements to the end of the collection.
    ///
    /// This method edits the `Nonempty` receiver and maintains its guarantee that the underlying contents are nonempty.
    ///
    /// > Warning: If the underlying collection mutates to become empty after appending the elements, this method will raise a fatal error.
    public mutating func append<S>(contentsOf newElements: S) where S : Sequence, Content.Element == S.Element {
        content._content.append(contentsOf: newElements)
        precondition(!content.isEmpty)
    }
    
    /// Inserts an element at the specified index within the collection.
    ///
    /// This method edits the `Nonempty` receiver and maintains its guarantee that the underlying contents are nonempty.
    ///
    /// > Warning: If the underlying collection mutates to become empty after appending the element, this method will raise a fatal error.
    public mutating func insert(_ newElement: Content.Element, at i: Content.Index) {
        content._content.insert(newElement, at: i)
        precondition(!content.isEmpty)
    }
    
    /// Inserts a sequence of elements at the specified index within the collection.
    ///
    /// This method edits the `Nonempty` receiver and maintains its guarantee that the underlying contents are nonempty.
    ///
    /// > Warning: If the underlying collection mutates to become empty after appending the element, this method will raise a fatal error.
    public mutating func insert<S>(contentsOf newElements: S, at i: Content.Index) where S : Collection, Content.Element == S.Element {
        content._content.insert(contentsOf: newElements, at: i)
        precondition(!content.isEmpty)
    }
}
