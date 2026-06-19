import XCTest
@testable import AlcoholTrackerCore

final class SemanticVersionTests: XCTestCase {

    // MARK: Parsing

    func test_parses_plain_version_string() {
        let version = SemanticVersion(parsing: "1.2.3")
        XCTAssertEqual(version, SemanticVersion(major: 1, minor: 2, patch: 3))
    }

    func test_parses_v_prefixed_tag() {
        let version = SemanticVersion(parsing: "v0.1.0")
        XCTAssertEqual(version, SemanticVersion(major: 0, minor: 1, patch: 0))
    }

    // Edge case 1: malformed strings yield nil rather than a bogus version.
    func test_rejects_malformed_strings() {
        XCTAssertNil(SemanticVersion(parsing: "1.2"))
        XCTAssertNil(SemanticVersion(parsing: "1.2.x"))
        XCTAssertNil(SemanticVersion(parsing: "v"))
        XCTAssertNil(SemanticVersion(parsing: ""))
        XCTAssertNil(SemanticVersion(parsing: "1.2.3.4"))
    }

    // MARK: Ordering (spec: versions are monotonic; a release tag is strictly greater)

    func test_ordering_is_monotonic_across_components() {
        XCTAssertLessThan(sv("1.0.0"), sv("2.0.0"))
        XCTAssertLessThan(sv("1.1.0"), sv("1.2.0"))
        XCTAssertLessThan(sv("1.2.3"), sv("1.2.4"))
        XCTAssertGreaterThan(sv("2.0.0"), sv("1.9.9"))
    }

    func test_equal_versions_are_not_strictly_greater() {
        XCTAssertEqual(sv("1.2.3"), sv("1.2.3"))
        XCTAssertFalse(sv("1.2.3") < sv("1.2.3"))
    }

    // Edge case 2: a candidate equal to the latest tag is NOT a valid next release.
    func test_next_release_must_be_strictly_greater_than_latest() {
        let latest = sv("1.4.2")
        XCTAssertFalse(sv("1.4.2") > latest) // equal — rejected
        XCTAssertFalse(sv("1.4.1") > latest) // lower — rejected
        XCTAssertTrue(sv("1.4.3") > latest)  // patch bump — accepted
        XCTAssertTrue(sv("2.0.0") > latest)  // major bump — accepted
    }

    func test_round_trips_through_description() {
        let version = sv("3.5.7")
        XCTAssertEqual(version.description, "3.5.7")
        XCTAssertEqual(SemanticVersion(parsing: version.description), version)
    }

    // MARK: Helpers

    private func sv(_ string: String) -> SemanticVersion {
        guard let version = SemanticVersion(parsing: string) else {
            fatalError("test fixture expected a valid version string: \(string)")
        }
        return version
    }
}
