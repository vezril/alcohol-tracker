# Alcohol Tracker

An iOS habit app for tracking alcohol intake, built with Swift, SwiftUI, and
(later) HealthKit. Design-inspired by [Intake](https://intakeapp.app/). An Apple
Watch widget is planned once core functionality is in place.

> **Status:** Feature 1 — project scaffolding & CI/CD. The app currently ships a
> placeholder root view; tracking features arrive in later milestones.

## Architecture at a glance

Business logic lives in a **Swift package** (`AlcoholTrackerCore`) so it can be
unit-tested on the plain Swift toolchain with `swift test` — no Xcode or
simulator required. The iOS app is a thin SwiftUI shell that depends on the
package. Its Xcode project is **generated** from [`App/project.yml`](App/project.yml)
with [XcodeGen](https://github.com/yonaskolb/XcodeGen) and is **not** committed
(no `project.pbxproj` merge conflicts).

```
.
├── Package.swift                 # SwiftPM: AlcoholTrackerCore library + tests
├── Sources/AlcoholTrackerCore/   # Functional, testable business logic
├── Tests/AlcoholTrackerCoreTests/
├── App/
│   ├── project.yml               # XcodeGen spec (iOS 26 app + unit-test target)
│   ├── Sources/                  # SwiftUI app (@main, RootView)
│   └── Tests/                    # iOS app smoke test
├── Scripts/assert-tests-ran.sh   # Fails CI if zero tests were discovered
└── .github/workflows/            # ci.yml (build+test), release.yml (archive)
```

## Prerequisites

| Tool | Version | Notes |
| --- | --- | --- |
| **Xcode** | 26.x | Required for the iOS 26 SDK, simulator, and `xcodebuild`. Install from the App Store. |
| **Swift toolchain** | 6.x | Bundled with Xcode. |
| **XcodeGen** | 2.45+ | `brew install xcodegen` — generates the app's Xcode project. |

> The minimum iOS **deployment target is iOS 26** (matches the maintainer's
> device). CI selects Xcode 26 on a macOS runner; adjust `XCODE_VERSION` /
> `IOS_DESTINATION` / `runs-on` in the workflows together if GitHub's runner
> images change.

## Build & run the app

```bash
# 1. Generate the Xcode project from the declarative spec
cd App && xcodegen generate && cd ..

# 2a. Open in Xcode and run (⌘R) on an iOS 26 simulator
open App/AlcoholTracker.xcodeproj

# 2b. …or build from the command line
xcodebuild build \
  -project App/AlcoholTracker.xcodeproj \
  -scheme AlcoholTracker \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.0' \
  CODE_SIGNING_ALLOWED=NO
```

## Run the tests

The test commands below are **identical to what CI runs** (see
[`.github/workflows/ci.yml`](.github/workflows/ci.yml)), so a local green run
reproduces the CI gate.

```bash
# Core business logic (fast; no simulator needed)
swift test

# iOS app + smoke test (requires an iOS 26 simulator)
cd App && xcodegen generate && cd ..
xcodebuild test \
  -project App/AlcoholTracker.xcodeproj \
  -scheme AlcoholTracker \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.0' \
  CODE_SIGNING_ALLOWED=NO
```

We follow **Test-Driven Development** (Red → Green → Refactor): write a failing
test first, make it pass with the simplest change, then refactor. The
`Scripts/assert-tests-ran.sh` guard fails the build if a suite reports zero
executed tests, so an empty/broken suite can never pass silently.

## Branching model

This project uses a GitFlow-lite model:

| Branch | Purpose |
| --- | --- |
| `main` | Released code only. Protected. Every release is a `vX.Y.Z` tag. |
| `development` | Integration branch. **Default target for pull requests.** Experimental builds. |
| `feature/*` | Short-lived branches off `development`, merged back via PR. |

Open feature branches off `development`, PR into `development`, and never push
directly to `main`.

## Versioning & releases

We follow [Semantic Versioning 2.0.0](https://semver.org). Each release tag must
be a strictly greater, unique `vX.Y.Z` than the last (enforced in logic by
`SemanticVersion`).

**Cutting a release:**

1. Merge `development` → `main` once stable.
2. Update `CHANGELOG.md` (move items from *Unreleased* to the new version).
3. Tag `main`: `git tag vX.Y.Z && git push origin vX.Y.Z`.
4. The [`release.yml`](.github/workflows/release.yml) workflow builds and
   archives the app and uploads the `.xcarchive` as a workflow artifact.

### TestFlight distribution — TODO

Distribution is **not yet automated**. The release workflow archives only and
prints the remaining steps loudly so a green run is never mistaken for a shipped
build. To complete it (later milestone): add code-signing secrets (Distribution
certificate + provisioning profile), export a signed `.ipa`, and upload via
Fastlane `pilot` or `xcrun altool` using an App Store Connect API key stored in
GitHub Encrypted Secrets.

## Continuous integration

[`ci.yml`](.github/workflows/ci.yml) runs on every PR and on pushes to
`development`/`main`:

- **core-tests** — `swift test` for `AlcoholTrackerCore`.
- **ios-build-test** — `xcodegen generate` → `xcodebuild test` on an iOS 26 simulator.

Both jobs run the empty-suite guard so the gate fails on a compile error, a
failing test, or zero discovered tests.

## Project decisions

- **Hosting:** personal GitHub repository.
- **Distribution:** TestFlight (upload wiring is a documented TODO).
- **Minimum iOS:** 26.

## License

[MIT](LICENSE).
