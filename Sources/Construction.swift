
/// This error is thrown by ``Nonempty/init(require:)`` if the provided collection is empty.
public struct EmptyCollectionError: Error, Equatable {
    /// The type of empty collection that was provided.
    public let content: Any.Type
    
    /// Creates a new instance of this error.
    public init(content: Any.Type) {
        self.content = content
    }
    
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.content == rhs.content
    }
}

private func defaultFailedNonemptyContentAssertionHandler(_ type: Any.Type) {
    preconditionFailure("The \(type) collection passed was empty.")
}

#if compiler(>=6)
nonisolated(unsafe) private var handleFailedNonemptyContentAssertion: (Any.Type) -> Void =
    defaultFailedNonemptyContentAssertionHandler
#else
private var handleFailedNonemptyContentAssertion: (Any.Type) -> Void =
    defaultFailedNonemptyContentAssertionHandler
#endif

// For test use only.
func setNonemptyFailedContentAssertionHandler(_ handler: @escaping (Any.Type) -> Void) {
    handleFailedNonemptyContentAssertion = handler
}

extension Nonempty {
    /// Creates a new wrapper, asserting that the provided collection is nonempty.
    ///
    /// If the provided collection is empty, this constructor will raise a fatal error.
    public init(assert value: Content) {
        if let me = Self.init(value) {
            self = me
        } else {
            handleFailedNonemptyContentAssertion(Content.self)
            
            // This should never be executed unless unit tests
            // have overridden the assertion handler.
            self.storage = .unsafeUninitialized
        }
    }
    
    /// Creates a new wrapper, requiring that the provided collection is nonempty and throwing an error if it isn't.
    ///
    /// If the provided collection is empty, this constructor will throw an ``EmptyCollectionError``.
    public init(require value: Content) throws {
        guard let me = Self.init(value) else {
            throw EmptyCollectionError(content: Content.self)
        }
        
        self = me
    }
    
    /// Creates a new wrapper from an existing one.
    public init(_ nonempty: Self) {
        self = nonempty
    }
}
