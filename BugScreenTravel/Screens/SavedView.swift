import SwiftUI

/// The saved/favourites grid (2 columns). Shows an empty state with a "Start exploring" button
/// that switches to the Explore tab. Ported from `SavedScreen.kt`.
struct SavedView: View {
    @EnvironmentObject private var store: TravelStore
    @State private var path = NavigationPath()
    let onExplore: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if store.savedDestinations.isEmpty {
                    emptyState
                } else {
                    grid
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Destination.self) { destination in
                DestinationDetailView(destination: destination)
            }
        }
        .onAppear { BugScreen.screenViewed("saved") }
    }

    private var grid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Saved")
                    .textStyle(.displaySmall)
                    .foregroundStyle(AppColor.onBackground)
                    .padding(.top, 12)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(store.savedDestinations) { destination in
                        SavedCard(
                            destination: destination,
                            onOpen: { path.append(destination) },
                            onToggleSave: { store.toggleSaved(destination) }
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.system(size: 52))
                .foregroundStyle(AppColor.primary)
            Text("Nothing saved yet")
                .textStyle(.headlineSmall)
                .foregroundStyle(AppColor.onBackground)
            Text("Tap the heart on a place to keep it here for later.")
                .textStyle(.bodyMedium)
                .foregroundStyle(AppColor.onSurfaceVariant)
                .multilineTextAlignment(.center)
            Button(action: onExplore) {
                Text("Start exploring")
                    .textStyle(.labelLarge)
                    .foregroundStyle(AppColor.onPrimary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(AppColor.primary, in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .padding(32)
    }
}
