
/**
 Represents a nonempty collection.
 
 A ``Nonempty`` wrapper can be used in code to wrap a collection of elements that is known to be nonempty. The wrapper can only be constructed starting from a nonempty collection, and maintains this property throughout its use.
 
 You can use a nonempty wrapper to require that a client not provide a nonempty collection, or to state that a specific stored value remain nonempty through its usage.
 
 The wrapper is a collection itself, delegating storage to the wrapped collection, and can be used in place of the collection anywhere a [`Collection`](https://developer.apple.com/documentation/swift/collection) of the same kind would be accessed. It also exposes the [`BidirectionalCollection`](https://developer.apple.com/documentation/swift/bidirectionalcollection) and  [`RandomAccessCollection`](https://developer.apple.com/documentation/swift/randomaccesscollection) conformances of the underlying collection, if any. It will use the same indices and subsequence types as that collection.
 
 ## Construction
 
 To construct a Nonempty type, use any of its constructors. The default constructor, ``init(_:)-8e2ty``, will return `nil` if the collection is nonempty. If you want to require the collection to be nonempty, use ``init(require:)``, which throws an error, or ``init(assert:)``, which asserts that the collection is nonempty and will raise a fatal error if it is. For example:
 
 ```swift
 let array = [1, 2, 3]
 let one = Nonempty(array)
    // nil if `array` was empty.
 
 let two = try Nonempty(require: array)
    // non-nil; will throw if `array` was empty.
 
 let three = Nonempty(assert: array)
    // non-nil; if empty, will raise a fatal error.
 ```
 
 ## Accessing & Editing
 
 Not all of the original collection's API is available through a ``Nonempty`` wrapper. In particular, the wrapper's conformances only allow read access to its content. This prevents usage of content-editing methods that could cause the collection to become empty.
 
 However, additional API surface is available through the ``nonempty`` property, which returns a ``Projected`` view of the wrapper. This surface includes two kinds of access:
 
 - Variant methods and properties from the original conformances of the collection that return optional results, because collections may be empty, have counterparts in this view that return non-optional values. For example:
 
 ```swift
 let array = [1, 2, 3]
 let firstA = array.first
    // This is an Int?, because [Array] may be empty.
 
 let wrapped = Nonempty(assert: array)
 let firstB = wrapped.first
    // This is also an Int?, because we are using
    // Swift's Sequence conformance on Nonempty,
    // and Sequences may be empty.
 
 let firstC = wrapped.nonempty.first
    // This is an Int, not an optional.
 ```
 
 - Editing methods that preserve nonemptiness, where appropriate. For example:
 
 ```swift
 var array = Nonempty(assert: [1, 2, 3])
 array.append(4) // error:
    // editing methods aren't available through the
    // base Swift collection conformances of Nonempty.
 
 array.nonempty.append(4) // works.
 
 array.nonempty.remove(at: 1) // error:
    // methods that could cause the underlying collection
    // to become nonempty aren't available.
 ```
 
 If you need full access to the underlying type, use the ``content`` property to retrieve the delegated collection, then edit it. You may need to create a new ``Nonempty`` wrapper to prove that the content is not empty.
 
 ## Use as a Property Wrapper
 
 You can use ``Nonempty`` as a property wrapper (`@Nonempty`) to require a property to remain nonempty. The property will be read-only, and the ``nonempty`` view will become that property's projected value. For example:
 
 ```swift
 @Nonempty var array = [1, 2, 3]
 
 let first = $array.first // Int, rather than Int?
 let last = $array.last // Int, rather than Int?
 $array.append(4) // works.
 
 array.append(4) // error:
   // the collection will be immutable while exposed through the
   // property wrapper.
 ```
 
 Initializing a wrapped property is equivalent to invoking ``init(assert:)``; it will produce a fatal error if the provided collection is empty. If you would like to be safe, you can use another ``Nonempty`` wrapper as the value of the initializer; this will unwrap the underlying collection rather than "double-wrap" the wrapper:
 
 ```swift
 let array = Nonempty(assert: [1, 2, 3])
 
 @Nonempty var values = array
 print(type(of: values))
   // This type is [Int], rather than Nonempty<Nonempty<[Int]>>.
 ```
 
 To pass a wrapped property to a ``Nonempty`` argument, use the underscored form of the value:
 
 ```swift
 func average(of values: Nonempty<[Int]>) -> Double {
     // …
 }
 
 @Nonempty var values = [1, 2, 3]
 let result = average(of: _values)
 ```
 
 > Note: While ``Nonempty`` can be used as a property wrapper on an argument, this may produce fatal errors. The wrapped argument will accept any collection, and then attempt to initialize the wrapper with ``init(assert:)``, which will produce a fatal error if the collection is empty. This removes the ability to communicate this requirement to your callers.
 >
 > Use the wrapper this way if the caller should not be aware of ``Nonempty``, but you still want to check the prerequisite. Otherwise, prefer using the ``Nonempty`` type in your interface directly. For example, this may inadvertently raise a fatal error:
 >
 > ```swift
 > func average(@Nonempty of values: [Int]) -> Double {
 >    // …
 > }
 >
 > let result = average(of: []) // fatal error.
 > ```
 >
 > This will require the caller to ensure a nonempty collection, and is preferred:
 >
 > ```swift
 > func average(of values: Nonempty<[Int]>) -> Double {
 >    // …
 > }
 >
 > let resultA = average(of: []) // this will not compile:
 >    // the caller will have to ensure that
 >    // the collection is nonempty by creating a
 >    // `Nonempty` wrapper.
 >
 > let resultB = average(of: Nonempty(assert: [1, 2, 3])) // works.
 > ```
 */
@propertyWrapper
public struct Nonempty<Content: Collection> {
    // For unit testing, a nonempty value may have failed initialization.
    // This should not be something that happens in normal operation,
    // since `handleFailedNonemptyContentAssertion` should not return unless
    // overridden in unit tests.
    enum Storage {
        case content(Content)
        case unsafeUninitialized
    }
    
    var storage: Storage
    public var content: Content {
        get {
            if case .content(let content) = storage {
                return content
            }
            
            preconditionFailure("This instance was not initialized correctly.")
        }
        set {
            storage = .content(newValue)
        }
    }
    
    @_disfavoredOverload
    public init?(_ content: Content) {
        guard !content.isEmpty else {
            return nil
        }
        
        self.storage = .content(content)
    }
    
    init(_assertUnchecked content: Content) {
        self.storage = .content(content)
    }
    
    public var nonempty: Projected {
        get { projectedValue }
        set { projectedValue = newValue }
    }
    
    public var wrappedValue: Content {
        content
    }
    
    @_disfavoredOverload
    public init(wrappedValue: Content) {
        self = Nonempty(assert: wrappedValue)
    }
    
    public init(wrappedValue: Nonempty<Content>) {
        self = wrappedValue
    }
    
    public init(projectedValue: Projected) {
        self = projectedValue.content
    }
    
    // -----
    
    public struct Projected {
        public var first: Content.Element {
            content.first!
        }
        
        public func max(by: (_ lhs: Content.Element, _ rhs: Content.Element) -> Bool) -> Content.Element {
            content.max(by: by)!
        }
        
        public func min(by: (_ lhs: Content.Element, _ rhs: Content.Element) -> Bool) -> Content.Element {
            content.min(by: by)!
        }
        
        public func separatingFirst() -> (first: Content.Element, suffix: Content.SubSequence) {
            return (first, content[content.index(after: content.startIndex)...])
        }
        
        public func map<X>(_ transform: (Content.Element) -> X) -> Nonempty<[X]> {
            .init(_assertUnchecked: Array(content.map(transform)))
        }
        
        public internal(set) var content: Nonempty<Content>
    }
    
    public var projectedValue: Projected {
        get { .init(content: self) }
        set { self = newValue.content }
    }
}

extension Nonempty: Sendable where Content: Sendable {}
extension Nonempty: Equatable where Content: Equatable {}
extension Nonempty.Storage: Equatable where Content: Equatable {}
extension Nonempty: Hashable where Content: Hashable {}
extension Nonempty.Storage: Hashable where Content: Hashable {}
