## Why

The alcohol-tracker app currently has no repository, no buildable project, and no automated quality gate. Before any feature work can follow a TDD workflow, we need a minimal but buildable Swift/SwiftUI project, a test target that actually runs, and CI/CD that builds and tests every change. This is Feature 1 of the roadmap and the foundation every later feature depends on.

## What Changes

- Initialize a Git repository with a `main`/`development` branch model and semantic-versioning conventions.
- Scaffold a minimal, buildable iOS app target (SwiftUI lifecycle) plus a unit-test target containing one trivial passing test — just enough for a meaningful Red-Green-Refactor loop and a green CI run. (The full app navigation shell is Feature 2.)
- Add GitHub Actions CI: build + run unit tests on pull requests and pushes to `development` and `main`.
- Add a GitHub Actions release pipeline keyed to semantic-version tags on `main` (build + archive; distribution wiring stubbed/documented).
- Add a comprehensive root `README.md` covering how to build, run the app, and run the tests, plus the branching/versioning strategy.
- Add supporting repo hygiene: `.gitignore` (Swift/Xcode/macOS), license placeholder, and a `CHANGELOG.md` seed.

## Capabilities

### New Capabilities
- `project-scaffolding`: A minimal buildable Swift/SwiftUI app target and a runnable unit-test target, repository initialization with `.gitignore`, and a root `README.md` documenting build/run/test workflows.
- `ci-cd-pipeline`: GitHub Actions workflows that build and test on every PR/push, a tag-driven release workflow on `main`, and a documented `main`/`development` branching model with semantic versioning.

### Modified Capabilities
<!-- None — this is the first change; no existing specs. -->

## Impact

- New repository at `/Users/cference/Code/alcohol-tracker` (currently not a Git repo).
- New Xcode project: one app target, one unit-test target.
- New `.github/workflows/` (CI + release), `.gitignore`, `README.md`, `CHANGELOG.md`, license.
- Establishes conventions (branching, semver, TDD CI gate) that all later features inherit.
- Dependency on GitHub-hosted macOS runners (Xcode toolchain) for CI; no third-party app dependencies introduced.
