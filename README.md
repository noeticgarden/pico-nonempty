## Noetic Garden: Picos

<img src="Docs/Picos.png" width="72" height="72" alt="" />

[Noetic Garden is a dream by millenomi.](https://noetic.garden)

Noetic Garden Picos are tiny packages of small, oft-repeated functionality that I carry project to project. Feel free to use them in yours. Picos are tested on Apple OSes, Linux, and Windows.

# Nonempty

The Nonempty package includes `Nonempty`, a wrapper type that you can use to assert that a collection is nonempty.

You can use this type to:

- Show to the compiler that a specific collection will not be empty when used. Use the built-in `nonempty` projection to access useful variants of regular collection API without having to handle optionals, and returning `Nonempty` wrappers to prove that your edit did not cause the collection to shrink.

- Indicate in your interfaces that a nonempty collection is required without having to cause precondition failures when accepting an empty one.

You can use this as its own type, or as a property wrapper to keep accessing the full API of the underlying collection type.

For example:

```swift
var numbers = Nonempty(assert: [1, 2, 3, 4])

// Only perform operations that maintain the nonempty property:
numbers.remove(at: 0) // compiler error!
numbers.nonempty.append(5) // works!
let double = numbers.nonempty.map {
	$0 * 2
} // double is a Nonempty<[Int]>!

// Use the nonempty type as a collection itself:
for number in numbers {
	print(number)
}
let maybeFirst = numbers.first // Optional<Int>: 1

// … and avoid optionals if needed:
let first = numbers.nonempty.first // Int: 1

// Use this as a property wrapper:
@Nonempty var newNumbers = numbers
$numbers.append(6)
let last = $numbers.last // Int: 6
print(type(of: newNumbers)) // Array<Int>
```

### Using this Package:

Add this repository as a Swift Package Manager dependency:

```swift
.package(url: "https://github.com/noeticgarden/pico-nonempty.git", from: "1.0")
```

Then, use the `Nonempty` module:

```
dependencies: [
	.product("Nonempty", package: "pico-nonempty"),
]
```

### Issues and Support

Use this repository's Issues tab to report issues. Pull requests are welcome with owner review. All support and PR acceptance is best-effort and not guaranteed.