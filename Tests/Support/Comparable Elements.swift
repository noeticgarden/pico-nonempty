
#if compiler(>=6) && canImport(Testing)
import Testing
import Nonempty

@Suite
struct ComparableElementsTests {
    @Test func projection() async throws {
        @Nonempty var value = [1, 2, 3, 4, 5]
        
        #expect($value.max() == 5)
        #expect($value.min() == 1)
    }
}

#endif
