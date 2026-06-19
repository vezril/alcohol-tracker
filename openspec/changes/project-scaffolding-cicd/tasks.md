## 1. Repository initialization

- [x] 1.1 Run `git init`; create `main`, then branch `development` and set it as the working default
- [x] 1.2 Add a Swift/Xcode/macOS `.gitignore` (derived data, build products, `xcuserdata`, `.DS_Store`)
- [x] 1.3 Add a license placeholder and a seed `CHANGELOG.md` (Keep a Changelog format, `v0.1.0` unreleased section)
- [x] 1.4 Verify hygiene: build artifacts, `.DS_Store`, and `xcuserdata` show as ignored in `git status`

## 2. App + test target scaffold (TDD: test first)

- [x] 2.1 RED — unit-test target with a failing test; verified FAILS (CI gate failed on red — see PR #1)
- [x] 2.2 GREEN — minimal SwiftUI app target (iOS 26) + placeholder root view; `SemanticVersion` passing tests green on CI (`swift test`)
- [x] 2.3 RED — empty/zero-test discovery treated as failure via `Scripts/assert-tests-ran.sh`; guard verified locally
- [x] 2.4 GREEN — suite discovered and passing; guard wired into both CI jobs and green
- [x] 2.5 App builds for an iOS Simulator destination via `xcodebuild` (CI `ios-build-test` job green)
- [x] 2.6 REFACTOR — business logic isolated in `AlcoholTrackerCore` (no SwiftUI coupling); tests green

## 3. CI workflow (build + test gate)

- [x] 3.1 Add `.github/workflows/ci.yml` triggering on PRs and pushes to `development`/`main`; Xcode pinned, simulator chosen at runtime
- [x] 3.2 Job runs `swift test` + `Scripts/ios-test.sh` (`xcodebuild test`); identical to documented local commands
- [x] 3.3 CI passes on a green branch (`development` run green)
- [x] 3.4 CI fails on a failing test (verified live via PR #1, conclusion: failure), then reverted
- [x] 3.5 Re-run of the green run reproduces success (determinism verified)

## 4. Release workflow (tag-driven archive)

- [x] 4.1 Add `.github/workflows/release.yml` triggered only on `v*` (semver `vX.Y.Z`) tags; `xcodebuild archive` + artifact upload
- [x] 4.2 Document the TestFlight upload path as explicit TODO in the workflow and README (App Store Connect API key + Fastlane `pilot`/`xcrun altool`, secrets in GitHub Encrypted Secrets); no silent skip
- [ ] 4.3 Verify a `v0.1.0` tag on `main` triggers the workflow and produces an archive artifact  _(awaiting authorization to cut the first release — touches protected `main`)_
- [ ] 4.4 Verify a non-semver tag does NOT trigger the release workflow  _(tag glob + validation regex verified locally; live check bundled with 4.3)_

## 5. Documentation and branching policy

- [x] 5.1 Write root `README.md`: project overview, prerequisites (Xcode version supporting iOS 26), build, run-in-simulator (iOS 26), and test commands
- [x] 5.2 README build/test commands exactly match CI (both call `swift test` + `Scripts/ios-test.sh`)
- [x] 5.3 Document the `main`/`development` + `feature/*` branching model and Semantic Versioning 2.0.0 policy (including release-cut procedure) in the README
- [x] 5.4 README commands succeed from a fresh checkout (CI checks out fresh and runs the documented commands green)
- [x] 5.5 Branch protection on `main` requires both CI checks + blocks force-push/deletion

## 6. Finalize

- [x] 6.1 Full test suite green (CI: core `swift test` + iOS `xcodebuild test`)
- [x] 6.2 Push the scaffolding; CI green on `development` (bootstrap lands as the initial commit; feature→PR flow begins with Feature 2)
- [x] 6.3 Created the personal public GitHub remote (`vezril/alcohol-tracker`), pushed `main` + `development`, decisions recorded in README/CHANGELOG

## Implementation notes

Local toolchain is **Command Line Tools only** (no Xcode), which ships no test
framework — so test *execution* was performed on **GitHub Actions** (Xcode 26.0.1
runners) rather than locally. Both CI jobs are green on `development`: core
`swift test` (the `SemanticVersion` TDD suite) and iOS `xcodebuild test` (app
build + smoke test). The gate was proven to fail on a red test (PR #1) and to be
deterministic across re-runs. Remaining: cutting the first `v0.1.0` release on
`main` (4.3) + the non-semver no-trigger check (4.4), both deferred pending
authorization since they touch the protected `main` branch / publish a release.
