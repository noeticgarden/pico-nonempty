
#if compiler(>=6) && canImport(Testing)
import Testing
import Nonempty

@Suite
struct RangeReplaceableCollectionConformanceTests {
    func testConformances<X: RangeReplaceableCollection>(original: X, appendingOne: X.Element, appendingAll: [X.Element]) where X.Element: Equatable {
        let nonempty = Nonempty(assert: original)
        
        do {
            var original = original
            var nonempty = nonempty
            
            original.append(appendingOne)
            nonempty.nonempty.append(appendingOne)
            
            #expect(Array(original) == Array(nonempty.content))
        }
        
        do {
            var original = original
            var nonempty = nonempty
            
            original.append(contentsOf: appendingAll)
            nonempty.nonempty.append(contentsOf: appendingAll)
            
            #expect(Array(original) == Array(nonempty.content))
        }
        
        do {
            var original = original
            var nonempty = nonempty
            
            original.insert(appendingOne, at: original.startIndex)
            nonempty.nonempty.insert(appendingOne, at: nonempty.startIndex)
            
            #expect(Array(original) == Array(nonempty.content))
        }
        
        do {
            var original = original
            var nonempty = nonempty
            
            original.insert(contentsOf: appendingAll, at: original.startIndex)
            nonempty.nonempty.insert(contentsOf: appendingAll, at: nonempty.startIndex)
            
            #expect(Array(original) == Array(nonempty.content))
        }
    }
    
    @Test func conformances() async throws {
        testConformances(
            original: [1, 2, 3, 4, 5],
            appendingOne: 123,
            appendingAll: [3, 4, 5]
        )
        testConformances(
            original: "Wowowowow",
            appendingOne: "!",
            appendingAll: Array("!!!!!!!!!!!?")
        )
    }
}

#endif
