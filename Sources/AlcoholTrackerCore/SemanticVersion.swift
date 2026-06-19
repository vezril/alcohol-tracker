/// A [Semantic Versioning 2.0.0](https://semver.org) `MAJOR.MINOR.PATCH` version.
///
/// Used by the release process to guarantee that every release tag is a strictly
/// greater, unique version than the previous one. Pre-release and build-metadata
/// suffixes are intentionally out of scope for the scaffolding milestone.
public struct SemanticVersion: Sendable, Hashable, Comparable, CustomStringConvertible {
    public let major: Int
    public let minor: Int
    public let patch: Int

    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    /// Parses a `MAJOR.MINOR.PATCH` string, tolerating an optional leading `v`
    /// (e.g. `"v0.1.0"`). Returns `nil` for any string that is not exactly three
    /// non-negative integer components.
    public init?(parsing string: String) {
        let normalized = string.hasPrefix("v") ? String(string.dropFirst()) : string
        let components = normalized.split(separator: ".", omittingEmptySubsequences: false)
        guard components.count == 3 else { return nil }

        let numbers = components.compactMap { Int($0) }
        guard numbers.count == 3, numbers.allSatisfy({ $0 >= 0 }) else { return nil }

        self.init(major: numbers[0], minor: numbers[1], patch: numbers[2])
    }

    public var description: String { "\(major).\(minor).\(patch)" }

    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        (lhs.major, lhs.minor, lhs.patch) < (rhs.major, rhs.minor, rhs.patch)
    }
}
