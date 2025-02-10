
extension Nonempty.Projected where Content.Element: Comparable {
    public func max() -> Content.Element {
        return content.max()!
    }
    
    public func min() -> Content.Element {
        return content.min()!
    }
}
