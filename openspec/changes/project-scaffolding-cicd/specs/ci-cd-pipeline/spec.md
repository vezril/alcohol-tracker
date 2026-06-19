## ADDED Requirements

### Requirement: Continuous integration on pull requests and pushes
The system SHALL run a GitHub Actions CI workflow that builds the app and runs the unit-test suite on every pull request and on pushes to `development` and `main`, failing the check when the build or any test fails.

#### Scenario: CI passes on a green change
- **GIVEN** a pull request whose code builds and whose tests pass
- **WHEN** the CI workflow runs on a macOS runner against an iOS Simulator destination
- **THEN** the workflow reports success and the PR check is green

#### Scenario: CI fails on a failing test
- **GIVEN** a pull request that introduces a failing unit test
- **WHEN** the CI workflow runs
- **THEN** the workflow reports failure and blocks the PR check

#### Scenario: Edge case — CI fails on a compile error
- **GIVEN** a pull request that does not compile
- **WHEN** the CI workflow runs
- **THEN** the workflow fails at the build step with a clear error, before reaching the test step

#### Scenario: Edge case — CI is deterministic across reruns
- **GIVEN** a green pull request
- **WHEN** the CI workflow is re-run without code changes
- **THEN** it produces the same success result, with a pinned Xcode version and a fixed simulator destination to avoid environment drift

### Requirement: Tag-driven release pipeline on main
The system SHALL run a GitHub Actions release workflow triggered by semantic-version tags (`vX.Y.Z`) that builds and archives the app, with distribution/signing steps documented as TODO rather than silently skipped.

#### Scenario: Release workflow archives on a version tag
- **GIVEN** a `vX.Y.Z` tag pushed on `main`
- **WHEN** the release workflow runs
- **THEN** it builds and archives the app and uploads the archive as a workflow artifact

#### Scenario: Edge case — non-semver tag does not trigger a release
- **GIVEN** a tag that does not match the `vX.Y.Z` pattern
- **WHEN** it is pushed
- **THEN** the release workflow does not run

#### Scenario: Edge case — release pipeline surfaces unimplemented distribution
- **GIVEN** the release workflow without signing/distribution credentials configured
- **WHEN** it runs on a version tag
- **THEN** it completes the archive step and clearly reports distribution as a documented TODO, so a green run is not mistaken for a shipped build

### Requirement: Branching model and semantic versioning policy
The system SHALL document and enforce a `main`/`development` branching model with short-lived feature branches and Semantic Versioning 2.0.0, where `main` holds released code and `development` is the integration branch.

#### Scenario: Default integration target is development
- **GIVEN** the documented branching policy
- **WHEN** a contributor opens a pull request for new work
- **THEN** the policy directs it to target `development`, not `main`

#### Scenario: Releases are cut as semver tags from main
- **GIVEN** stable code merged from `development` into `main`
- **WHEN** a release is cut
- **THEN** it is tagged `vX.Y.Z` following Semantic Versioning, and the version increments per change type (major/minor/patch)

#### Scenario: Edge case — direct pushes to main are discouraged/blocked
- **GIVEN** the branching policy and (where available) branch protection on `main`
- **WHEN** a contributor attempts to push directly to `main`
- **THEN** the policy requires the change to go through `development` and a pull request

#### Scenario: Edge case — version numbers are monotonic and unique
- **GIVEN** an existing release tag `vX.Y.Z`
- **WHEN** a new release is prepared
- **THEN** the new tag is a strictly greater semantic version and the same tag is never reused
