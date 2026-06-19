## ADDED Requirements

### Requirement: Buildable iOS app target
The system SHALL provide a SwiftUI iOS application target that compiles and launches from a clean checkout, with no tracking features beyond a placeholder root view.

#### Scenario: App builds from clean checkout
- **GIVEN** a fresh clone of the repository with no derived data
- **WHEN** the app target is built with `xcodebuild` for an iOS Simulator destination
- **THEN** the build succeeds with no errors

#### Scenario: App launches to a placeholder root view
- **GIVEN** the built app
- **WHEN** it is launched in the iOS Simulator
- **THEN** it presents a placeholder root view without crashing

#### Scenario: Edge case — build fails on missing Xcode toolchain
- **GIVEN** an environment without a compatible Xcode/command-line toolchain
- **WHEN** a build is attempted
- **THEN** the build fails fast with a clear toolchain error rather than a partial/ambiguous failure

#### Scenario: Edge case — clean derived data does not change build result
- **GIVEN** a checkout whose derived data directory has been deleted
- **WHEN** the app target is rebuilt
- **THEN** the build still succeeds, proving the project is self-contained and not dependent on stale local state

### Requirement: Runnable unit-test target
The system SHALL provide a unit-test target that is discoverable and runnable via `xcodebuild test`, containing at least one passing test that proves the Red-Green-Refactor loop.

#### Scenario: Tests run and pass
- **GIVEN** the scaffolded test target
- **WHEN** `xcodebuild test` is run against an iOS Simulator destination
- **THEN** the test suite executes and all tests pass

#### Scenario: Edge case — a deliberately failing test reports as failed
- **GIVEN** a temporary test asserting a known-false condition
- **WHEN** the test suite is run
- **THEN** the run reports a non-zero exit status and identifies the failing test, proving the gate actually catches failures

#### Scenario: Edge case — empty/zero-test run is treated as a failure condition
- **GIVEN** a test target where no tests are discovered
- **WHEN** the test command is run
- **THEN** the outcome is treated as a failure (not a silent pass), so an empty suite cannot mask a broken setup

### Requirement: Repository initialization and hygiene
The system SHALL initialize a Git repository with a Swift/Xcode/macOS `.gitignore`, a license placeholder, and a seed `CHANGELOG.md`, so generated artifacts and local files are not committed.

#### Scenario: Git ignores Xcode build artifacts
- **GIVEN** the repository with the provided `.gitignore`
- **WHEN** the app is built and `git status` is inspected
- **THEN** derived data, user-specific Xcode state, and build products are untracked

#### Scenario: Edge case — `.DS_Store` and user data are not committable
- **GIVEN** a `.DS_Store` file and `xcuserdata` present in the working tree
- **WHEN** `git status` is inspected
- **THEN** those files are ignored and do not appear as tracked or staged

#### Scenario: Edge case — re-running init on an existing repo is non-destructive
- **GIVEN** an already-initialized repository
- **WHEN** initialization steps are re-applied
- **THEN** existing history and files are preserved (no overwrite of committed content)

### Requirement: Root README with build, run, and test instructions
The system SHALL include a root `README.md` documenting how to build the app, run it in the simulator, and run the tests, plus the branching and versioning policy.

#### Scenario: README documents the core workflows
- **GIVEN** the root `README.md`
- **WHEN** a new contributor reads it
- **THEN** it contains copy-pastable commands to build, run, and test, and a description of the `main`/`development` branching and semantic-versioning policy

#### Scenario: Edge case — documented test command matches CI
- **GIVEN** the test command in the README and the command used by the CI workflow
- **WHEN** the two are compared
- **THEN** they are equivalent, so following the README reproduces the CI gate locally

#### Scenario: Edge case — documented build command succeeds from a clean checkout
- **GIVEN** a fresh clone
- **WHEN** the exact build command from the README is executed
- **THEN** it succeeds, proving the documentation is accurate and not drifted
