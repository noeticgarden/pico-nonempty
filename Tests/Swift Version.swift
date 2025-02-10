
#if !(compiler(>=6) && canImport(Testing))
#warning("Testing requires Swift 6 and the Swift Testing framework.")

import XCTest

final class SwiftVersion: XCTestCase {
    func testRequiresSwift6() throws {
        XCTFail("Testing requires Swift 6 and the Swift Testing framework.")
    }
}
#endif
