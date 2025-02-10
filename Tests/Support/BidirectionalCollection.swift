
#if compiler(>=6) && canImport(Testing)
import Testing
import Nonempty

@Suite
struct BidirectionCollectionConformanceTests {
    func testConformances<X: BidirectionalCollection>(original: X) {
        let nonempty = Nonempty(assert: original)
        
        #expect(
            original.index(before: original.endIndex) ==
            nonempty.index(before: nonempty.endIndex)
        )
        
        do {
            var a = original.endIndex
            var b = nonempty.endIndex
            
            original.formIndex(before: &a)
            nonempty.formIndex(before: &b)
            
            #expect(a == b)
        }
    }
    
    @Test func conformances() async throws {
        testConformances(original: [1, 2, 3, 4, 5])
        testConformances(original: "Wowowowow")
    }
}

#endif
