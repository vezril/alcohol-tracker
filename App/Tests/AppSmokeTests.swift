import XCTest
import AlcoholTrackerCore

/// Smoke test for the iOS app's unit-test target. Its purpose is to give
/// `xcodebuild test` a real test to execute against an iOS Simulator destination
/// and to prove the app's test bundle links `AlcoholTrackerCore`.
final class AppSmokeTests: XCTestCase {
    func test_core_dependency_is_linked() {
        XCTAssertEqual(SemanticVersion(parsing: "v0.1.0"), SemanticVersion(major: 0, minor: 1, patch: 0))
    }
}
