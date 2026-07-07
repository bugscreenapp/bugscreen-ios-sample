import SwiftUI

/// The destinations feed — a vertical list of full-bleed hero cards. No search or filters, just
/// like the Android sample. Tapping a card opens its detail; the heart saves without navigating.
struct ExploreView: View {
    @EnvironmentObject private var store: TravelStore
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Explore")
                            .textStyle(.displaySmall)
                            .foregroundStyle(AppColor.onBackground)
                        Text("Where to next, \(firstName)?")
                            .textStyle(.bodyLarge)
                            .foregroundStyle(AppColor.onSurfaceVariant)
                    }
                    .padding(.top, 12)

                    ForEach(store.destinations) { destination in
                        DestinationCard(
                            destination: destination,
                            isSaved: store.isSaved(destination),
                            onOpen: { path.append(destination) },
                            onToggleSave: { store.toggleSaved(destination) }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColor.background)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Destination.self) { destination in
                DestinationDetailView(destination: destination)
            }
        }
        .onAppear { BugScreen.screenViewed("explore") }
    }

    private var firstName: String {
        store.currentUser.displayName.split(separator: " ").first.map(String.init)
            ?? store.currentUser.displayName
    }
}
