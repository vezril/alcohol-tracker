# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project scaffolding (Feature 1):
  - `AlcoholTrackerCore` Swift package for unit-testable, functional business logic.
  - Minimal SwiftUI iOS app shell (`AlcoholTracker`) targeting iOS 26, generated via XcodeGen.
  - `SemanticVersion` value type with parsing and monotonic ordering.
  - GitHub Actions CI (build + test) and tag-driven release (archive) workflows.
  - `main` / `development` branching model and Semantic Versioning policy.
  - Repository hygiene: `.gitignore`, MIT license, README.

### Project decisions
- Hosting: personal GitHub repository.
- Distribution: TestFlight (upload wiring is a documented TODO; release workflow archives only).
- Minimum iOS deployment target: iOS 26.

[Unreleased]: https://github.com/vezril/alcohol-tracker/compare/HEAD
