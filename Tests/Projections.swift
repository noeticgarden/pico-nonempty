
#if compiler(>=6) && canImport(Testing)
import Testing
import Nonempty

@Suite
struct ProjectionTests {
    @Test func first() {
        @Nonempty var ints = [1, 3, 5, 7]
        #expect($ints.first == ints.first)
        #expect(type(of: $ints.first) == Int.self)
    }
    
    @Test func max() {
        @Nonempty var strings = [
            "a",
            "aa",
            "aaaaaaa",
            "aaaaaaaaaaaaaaaaaaaaaaaa",
        ]
        
        let max = $strings.max {
            $0.count < $1.count
        }
        #expect(max == strings.last)
        #expect(type(of: max) == String.self)
    }
    
    @Test func min() {
        @Nonempty var strings = [
            "a",
            "aa",
            "aaaaaaa",
            "aaaaaaaaaaaaaaaaaaaaaaaa",
        ]
        
        let max = $strings.min {
            $0.count < $1.count
        }
        #expect(max == strings.first)
        #expect(type(of: max) == String.self)
    }
    
    @Test func separatingFirst() async throws {
        @Nonempty var value = [1, 2, 3, 4, 5]
        
        let (head, tail) = $value.separatingFirst()
        #expect(head == 1)
        #expect(Array(tail) == [2, 3, 4, 5])
    }
    
    @Test func map() async throws {
        @Nonempty var value = [1, 2, 3, 4, 5]
        
        let doubles = $value.map { $0 * 2 }
        #expect(Array(doubles) == [2, 4, 6, 8, 10])
        #expect(type(of: doubles) == Nonempty<[Int]>.self)
    }
}

#endif
