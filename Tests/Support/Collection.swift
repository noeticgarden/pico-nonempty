
#if compiler(>=6) && canImport(Testing)
import Testing
import Nonempty

@Suite
struct CollectionConformanceTests {
    @Test func basicUsage() async throws {
        let array = [1, 2, 3, 4, 5]
        @Nonempty var values = array
        
        #expect(Array(_values) == array)
    }
    
    func testConformances<X: Collection>(original: X, equals: (X.Element, X.Element) -> Bool) {
        let nonempty = Nonempty(assert: original)
        
        #expect(original.isEmpty == nonempty.isEmpty)
        #expect(original.count == nonempty.count)
        #expect(original.startIndex == nonempty.startIndex)
        #expect(
            original.index(after: original.startIndex) ==
            nonempty.index(after: nonempty.startIndex)
        )
        
        do {
            var a = original.startIndex
            original.formIndex(after: &a)
            
            var b = nonempty.startIndex
            nonempty.formIndex(after: &b)
            
            #expect(a == b)
        }
        
        do {
            var a = original.startIndex
            original.formIndex(&a, offsetBy: 1)
            
            var b = nonempty.startIndex
            nonempty.formIndex(&b, offsetBy: 1)
            
            #expect(a == b)
        }
        
        do {
            let aStart = original.startIndex
            let a = original.index(aStart, offsetBy: 1, limitedBy: original.endIndex)
            
            let bStart = nonempty.startIndex
            let b = nonempty.index(bStart, offsetBy: 1, limitedBy: nonempty.endIndex)
            
            #expect(a == b)
        }
        
        #expect(
            original.distance(from: original.startIndex, to: original.endIndex) ==
            nonempty.distance(from: nonempty.startIndex, to: nonempty.endIndex)
        )
        
        #expect(Array(original.indices) == Array(nonempty.indices))
        
        for index in original.indices {
            #expect(equals(original[index], nonempty[index]))
        }
        
        let originalSlice = original[original.startIndex..<original.endIndex]
        let nonemptySlice = nonempty[nonempty.startIndex..<nonempty.endIndex]
        
        #expect(originalSlice.count == nonemptySlice.count)
        for index in originalSlice.indices {
            #expect(equals(originalSlice[index], nonemptySlice[index]))
        }
    }
    
    func testConformances<X: Collection>(original: X) where X.Element: Equatable {
        testConformances(original: original, equals: ==)
    }
    
    @Test func conformances() async throws {
        testConformances(original: [1, 2, 3, 4, 5])
        testConformances(original: "Wowowowow")
        testConformances(original: ["a": 1, "b": 2]) {
            $0.key == $1.key && $0.value == $1.value
        }
        testConformances(original: Set([1, 2, 3, 4, 5]))
    }
}

#endif
