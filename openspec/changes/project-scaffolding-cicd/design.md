## Context

The repository does not yet exist as a Git repo and there is no Xcode project. Every later roadmap feature requires a TDD loop (Red-Green-Refactor) running against a real, buildable target, and a CI gate that proves tests pass on every change. This change establishes that foundation: repo, minimal buildable app + test target, CI/CD, and the branching/versioning conventions.

The product is a native iOS app (Swift, SwiftUI, HealthKit) with an Apple Watch widget planned later. CI must run on macOS runners with an Xcode toolchain. The initial prompt invites refining the proposed branching strategy, which this design does.

## Goals / Non-Goals

**Goals:**
- A minimal SwiftUI app target that launches and a unit-test target that runs at least one test.
- A green CI run (build + test) on every PR and on pushes to `development`/`main`.
- A release workflow triggered by semantic-version tags on `main`.
- A documented branching model (`main`/`development`) and semantic-versioning policy.
- A root `README.md` covering build, run, and test instructions.
- An Xcode project that is reproducible/buildable from a clean checkout via command line (`xcodebuild`).

**Non-Goals:**
- The real app navigation shell, tabs, or any tracking features (Feature 2 onward).
- App Store / TestFlight distribution credentials and signing automation (stub + document only).
- HealthKit entitlements/integration (later feature).
- Apple Watch target (later feature).

## Decisions

### Decision 1: Project generation — checked-in `.xcodeproj` vs. XcodeGen/SwiftPM
**Choice (revised):** SwiftPM-first hybrid. Business logic lives in a Swift Package (`AlcoholTrackerCore`) that is unit-testable on the macOS toolchain via `swift test` — no Xcode or simulator required. The iOS app is a thin SwiftUI shell that depends on the package, with its `.xcodeproj` generated declaratively from `App/project.yml` via **XcodeGen** (no `.xcodeproj` checked in). GitHub Actions (which has Xcode) generates the project and runs the iOS build + simulator tests.
**Rationale:** The dev machine has the Swift 6.2 toolchain but *not* Xcode, so iOS `xcodebuild`/simulator tests cannot run locally. Keeping all testable logic in a SwiftPM package lets the Red-Green-Refactor loop run locally today (`swift test`), satisfying the non-negotiable TDD constraint, while CI remains the authority for iOS-specific build/UI verification. XcodeGen also eliminates `project.pbxproj` merge conflicts and keeps the repo project file human-readable.
**Alternatives considered:** Checked-in Xcode-generated `.xcodeproj` — impossible to author/verify without Xcode locally, and conflict-prone. Tuist — heavier than needed and not installed. Pure SwiftPM executable — not a valid iOS app bundle.
**Trade-off accepted:** Contributors and CI must run `xcodegen generate` (or `brew install xcodegen`) before opening/building the iOS app; documented in the README and run automatically in CI.

### Decision 2: Branching & versioning model
**Choice:** Refine the proposed model into GitFlow-lite:
- `main` — released code only; protected; every release is a `vX.Y.Z` tag; CI builds + archives on tag.
- `development` — integration branch; experimental builds; default PR target.
- `feature/*` — short-lived branches off `development`, merged via PR.
- Semantic Versioning 2.0.0; releases cut by merging `development` → `main` and tagging.
**Rationale:** Matches the prompt's `main`/`development` intent while adding short-lived feature branches and tag-driven releases, which make semver releases unambiguous and CI triggers clean.
**Alternatives considered:** Strict trunk-based (single branch + tags) — simpler but loses the requested experimental `development` line. Full GitFlow (release/hotfix branches) — heavier than a solo early-stage project needs.

### Decision 3: CI workflow shape
**Choice:** Two GitHub Actions workflows:
- `ci.yml` — on PRs and pushes to `development`/`main`: `xcodebuild test` against an iOS Simulator destination on a `macos-latest` runner; cache derived data/SwiftPM where helpful.
- `release.yml` — on `v*` tags: `xcodebuild archive`; upload the build artifact; distribution/signing steps stubbed and documented as TODO.
**Rationale:** Separates the fast always-on test gate from the heavier, rarer release path. Keeps the TDD gate fast.
**Alternatives considered:** Single combined workflow with conditionals — harder to read and reason about. Fastlane — powerful but an extra dependency not yet warranted.

### Decision 4: Test framework
**Choice:** XCTest for the scaffold's unit-test target (one trivial passing test to prove the loop).
**Rationale:** First-party, zero extra dependency, runs under `xcodebuild test` on CI. Swift Testing can be adopted later if desired.
**Alternatives considered:** Swift Testing (`swift-testing`) — newer/expressive; defer until the team has a preference, to avoid toolchain-version surprises on runners.

## Risks / Trade-offs

- **Checked-in `.xcodeproj` causes merge conflicts as targets grow** → Keep the scaffold single-target; revisit XcodeGen if conflicts recur.
- **GitHub macOS runner Xcode version drifts and breaks the build** → Pin the Xcode version in CI (e.g., via `xcode-select`/`maxim-lobanov/setup-xcode`) and document the expected version in the README.
- **Release signing not automated** → Explicitly scoped out; `release.yml` archives only and documents the manual/credentialed steps as TODO so a green pipeline is not mistaken for shippable distribution.
- **Simulator destination flakiness/availability on runners** → Choose a broadly available simulator (latest iOS on `macos-latest`) and allow the destination to be overridden via workflow input/env.
- **Logic coupled to SwiftUI views is hard to unit-test** → Keep business logic in plain, functional Swift types separated from views so tests don't require the simulator UI layer.

## Migration Plan

This is greenfield; no data or users to migrate.
1. `git init`; create `main`, then branch `development` as the working default.
2. Add `.gitignore`, license, `README.md`, `CHANGELOG.md`, and the Xcode project with app + test targets.
3. Add `ci.yml` and `release.yml`; push to a feature branch and open a PR into `development` to prove CI is green.
4. Merge to `development`; cut the first `v0.1.0` tag from `main` once the scaffold is stable to prove `release.yml`.
**Rollback:** Revert the feature-branch PR; no runtime state exists. If CI config is wrong, workflows can be disabled in repo settings without affecting code.

## Resolved Decisions

- **Repo hosting:** Personal GitHub repository. Branch protection on `main` configured after the first push (best-effort; some protection rules require specific account/repo tiers, so the documented policy is the primary enforcement).
- **Distribution target:** TestFlight. `release.yml` archives now; TestFlight upload (App Store Connect API key / Fastlane `pilot` or `xcrun altool`) is the documented next step, with signing secrets stored in GitHub Encrypted Secrets.
- **Minimum iOS deployment target:** iOS 26 (matches the developer's device). CI simulator destination and the Xcode version pin are chosen to support iOS 26.

## Open Questions

- None outstanding. (Distribution credential setup is deferred to the feature that wires up TestFlight upload, not this scaffolding change.)
