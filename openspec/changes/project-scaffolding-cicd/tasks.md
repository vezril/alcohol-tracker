## 1. Repository initialization

- [x] 1.1 Run `git init`; create `main`, then branch `development` and set it as the working default
- [x] 1.2 Add a Swift/Xcode/macOS `.gitignore` (derived data, build products, `xcuserdata`, `.DS_Store`)
- [x] 1.3 Add a license placeholder and a seed `CHANGELOG.md` (Keep a Changelog format, `v0.1.0` unreleased section)
- [x] 1.4 Verify hygiene: build artifacts, `.DS_Store`, and `xcuserdata` show as ignored in `git status`

## 2. App + test target scaffold (TDD: test first)

- [ ] 2.1 RED — Create the unit-test target with one failing test (assert a known-false condition); run `xcodebuild test`/`swift test` and confirm it FAILS  _(test written; execution pending Xcode install)_
- [ ] 2.2 GREEN — Create the minimal SwiftUI app target (minimum deployment target iOS 26) with a placeholder root view and flip the test to a trivial passing assertion; run tests and confirm PASSES  _(app + `SemanticVersion` implemented; `swift build` of the library is green; test execution pending Xcode)_
- [ ] 2.3 RED — Add a failing test proving an empty/zero-test discovery is treated as failure (e.g., a guard test/script check); run and confirm it FAILS  _(`Scripts/assert-tests-ran.sh` written; guard logic verified locally on zero/no-test input)_
- [ ] 2.4 GREEN — Implement the minimal setup so the suite is discovered and passes; run tests and confirm PASSES  _(guard wired into both CI jobs; passes on real-run input locally)_
- [ ] 2.5 Verify the app builds for an iOS Simulator destination via `xcodebuild` from a clean checkout (delete derived data first)  _(pending Xcode)_
- [ ] 2.6 REFACTOR — Separate any business logic from SwiftUI views into plain functional Swift types so logic is unit-testable without the simulator UI; re-run tests and confirm still PASSING  _(logic already isolated in `AlcoholTrackerCore`; re-run pending Xcode)_

## 3. CI workflow (build + test gate)

- [x] 3.1 Add `.github/workflows/ci.yml` triggering on PRs and pushes to `development`/`main`; pin the Xcode version and a fixed iOS Simulator destination
- [x] 3.2 Configure the job to run `xcodebuild test`; use the same command documented for local runs (Task 5.2)
- [ ] 3.3 Verify CI passes on a green branch (open a PR into `development`)  _(pending GitHub remote)_
- [ ] 3.4 Verify CI fails on a failing test and on a non-compiling change (temporary commits), then revert  _(pending GitHub remote)_
- [ ] 3.5 Verify a re-run of CI on an unchanged green PR reproduces success (determinism)  _(pending GitHub remote)_

## 4. Release workflow (tag-driven archive)

- [x] 4.1 Add `.github/workflows/release.yml` triggered only on `v*` (semver `vX.Y.Z`) tags; run `xcodebuild archive` and upload the archive as a workflow artifact
- [x] 4.2 Document the TestFlight upload path as explicit TODO in the workflow and README (App Store Connect API key + Fastlane `pilot`/`xcrun altool`, secrets in GitHub Encrypted Secrets); no silent skip
- [ ] 4.3 Verify a `v0.1.0` tag on `main` triggers the workflow and produces an archive artifact  _(pending GitHub remote)_
- [ ] 4.4 Verify a non-semver tag does NOT trigger the release workflow  _(tag glob + validation regex verified locally; cloud verification pending remote)_

## 5. Documentation and branching policy

- [x] 5.1 Write root `README.md`: project overview, prerequisites (Xcode version supporting iOS 26), build, run-in-simulator (iOS 26), and test commands
- [x] 5.2 Ensure the README's documented build and test commands exactly match the CI workflow commands
- [x] 5.3 Document the `main`/`development` + `feature/*` branching model and Semantic Versioning 2.0.0 policy (including release-cut procedure) in the README
- [ ] 5.4 Verify the README's build command succeeds from a fresh clone (accuracy check)  _(pending Xcode)_
- [ ] 5.5 (Where available) configure branch protection on `main` to require PRs and passing CI  _(pending GitHub remote)_

## 6. Finalize

- [ ] 6.1 Run the full test suite one final time and confirm all green  _(pending Xcode)_
- [ ] 6.2 Push the scaffolding; confirm CI is green on `development`  _(pending GitHub remote; bootstrap lands as the initial commit on `main`, with `development` branched from it — the feature→PR flow begins with Feature 2)_
- [ ] 6.3 Create the personal GitHub remote, push `main` + `development`, and record the resolved decisions (personal repo, TestFlight, iOS 26) in the README/CHANGELOG  _(decisions recorded in README/CHANGELOG; remote creation pending)_

## Implementation notes

Local toolchain is **Command Line Tools only** (no Xcode yet), which ships no
test framework, so test *execution* (`swift test` / `xcodebuild test`) is
deferred until Xcode 26 is installed. All test/app/CI **code is written**; the
core library compiles (`swift build` green), the XcodeGen spec generates a valid
project, the empty-suite guard is verified locally, and the semver tag filter is
verified locally. Remaining work is execution-only, split between **Xcode-install**
(2.x, 5.4, 6.1) and **GitHub-remote** (3.3–3.5, 4.3–4.4, 5.5, 6.2, 6.3) gates.
