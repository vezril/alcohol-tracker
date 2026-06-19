import SwiftUI
import AlcoholTrackerCore

/// Placeholder root view for the scaffolding milestone.
///
/// It also renders the marketing version via `SemanticVersion`, which proves the
/// app target links the `AlcoholTrackerCore` package at build time.
struct RootView: View {
    private static let version = SemanticVersion(major: 0, minor: 1, patch: 0)

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "drop.fill")
                .font(.system(size: 48))
                .foregroundStyle(.tint)
            Text("Alcohol Tracker")
                .font(.title.bold())
            Text("Scaffolding build · v\(Self.version.description)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    RootView()
}
