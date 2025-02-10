
public struct EmptyCollectionError: Error, Equatable {
    let content: Any.Type
    
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        String(reflecting: lhs.content) == String(reflecting: rhs.content)
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
    
    public init(require value: Content) throws {
        guard let me = Self.init(value) else {
            throw EmptyCollectionError(content: Content.self)
        }
        
        self = me
    }
    
    public init(_ nonempty: Self) {
        self = nonempty
    }
}
