
#if compiler(>=6) && canImport(Testing)
import Testing
@testable import Nonempty

final class FailedInitializations {
    var isFallback: Bool
    var each: [Any.Type] {
        didSet {
            assert(!isFallback)
        }
    }

    init(isFallback: Bool = false) {
        self.isFallback = isFallback
        self.each = []
    }
}
@TaskLocal var failedInitializations = FailedInitializations(isFallback: true)
func reportFailedInitialization(_ type: Any.Type) {
    failedInitializations.each.append(type)
}

let setReportFailedInitializations: Void = {
    setNonemptyFailedContentAssertionHandler(reportFailedInitialization(_:))
}()

@Suite
struct ConstructionTests {
    @Test func testRegular() throws {
        let fullArray = [1, 2, 3, 4, 5]
        let emptyArray: [Int] = []
        
        let nonempty = try #require(Nonempty(fullArray))
        #expect(nonempty.content == fullArray)
        
        #expect(Nonempty(emptyArray) == nil)
    }
    
    @Test func testRequire() throws {
        let fullArray = [1, 2, 3, 4, 5]
        let emptyArray: [Int] = []
        
        do {
            let nonempty = try Nonempty(require: fullArray)
            #expect(nonempty.content == fullArray)
        } catch {
            #expect(error == nil)
        }
        
        #expect(throws: EmptyCollectionError(content: [Int].self)) {
            try Nonempty(require: emptyArray)
        }
    }
    
    @Test func testAssert() throws {
        _ = setReportFailedInitializations
        
        let fullArray = [1, 2, 3, 4, 5]
        let emptyArray: [Int] = []
        
        try $failedInitializations.withValue(FailedInitializations()) {
            let nonempty = Nonempty(assert: fullArray)
            #expect(failedInitializations.each.isEmpty)
            #expect(nonempty.content == fullArray)
        
            _ = Nonempty(assert: emptyArray) // This would normally assert.
            try #require(failedInitializations.each.count == 1)
            #expect(failedInitializations.each[0] == [Int].self)
        }
    }
    
    @Test func testWrapper() throws {
        _ = setReportFailedInitializations
        
        let fullArray = [1, 2, 3, 4, 5]
        let emptyArray: [Int] = []
        
        try $failedInitializations.withValue(FailedInitializations()) {
            @Nonempty var full = fullArray
            #expect(failedInitializations.each.isEmpty)
            #expect(full == fullArray)
            
            @Nonempty var empty = emptyArray
            try #require(failedInitializations.each.count == 1)
            #expect(failedInitializations.each[0] == [Int].self)
        }
    }
    
    @Test func testUnwrapping() throws {
        @Nonempty var full = [1, 2, 3, 4, 5]
        
        let nonempty = Nonempty(_full)
        #expect(nonempty == _full)
        
        let nonempty2 = Nonempty(projectedValue: $full)
        #expect(nonempty2 == _full)
        
        @Nonempty var full2 = full
        #expect(full2 == full)
        
        @Nonempty var full3 = _full
        #expect(_full3 == _full)
    }
    
    @Test func testAssertUnchecked() throws {
        _ = setReportFailedInitializations
        
        let fullArray = [1, 2, 3, 4, 5]
        let emptyArray: [Int] = []
        
        $failedInitializations.withValue(FailedInitializations()) {
            let full = Nonempty(_assertUnchecked: fullArray)
            #expect(failedInitializations.each.isEmpty)
            #expect(full.content == fullArray)
            
            let empty = Nonempty(_assertUnchecked: emptyArray)
            #expect(failedInitializations.each.isEmpty)
            #expect(empty.content == emptyArray)
        }
    }
}

#endif
