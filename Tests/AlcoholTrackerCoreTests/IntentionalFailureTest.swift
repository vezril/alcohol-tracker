import XCTest

// TEMPORARY — verifies the CI gate fails on a failing test. Deleted after.
final class IntentionalFailureTest: XCTestCase {
    func test_intentionally_fails() {
        XCTFail("intentional failure to verify the CI gate blocks red builds")
    }
}
