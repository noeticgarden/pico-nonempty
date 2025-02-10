
#if compiler(>=6) && canImport(Testing)
import Testing
import Nonempty

@Suite
struct RandomAccessCollectionTests {
    @Test func projection() async throws {
        @Nonempty var value = [1, 2, 3, 4, 5]
        
        #expect($value.last == 5)
        let (head, tail) = $value.separatingLast()
        #expect(Array(head) == [1, 2, 3, 4])
        #expect(tail == 5)
    }
}

#endif
