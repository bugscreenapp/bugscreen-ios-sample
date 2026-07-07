import SwiftUI

/// The bottom-tab scaffold: Explore, Saved, Trips, Profile — each its own navigation stack.
/// A first-launch welcome dialog floats above everything. Ported from `TravelNavHost.kt`.
struct RootView: View {
    @StateObject private var store = TravelStore()
    @State private var selection: Tab = .explore
    @State private var showWelcome = true

    enum Tab: Hashable {
        case explore, saved, trips, profile
    }

    var body: some View {
        TabView(selection: $selection) {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: selection == .explore ? "safari.fill" : "safari")
                }
                .tag(Tab.explore)

            SavedView(onExplore: { selection = .explore })
                .tabItem {
                    Label("Saved", systemImage: selection == .saved ? "heart.fill" : "heart")
                }
                .tag(Tab.saved)

            TripsView()
                .tabItem {
                    Label("Trips", systemImage: selection == .trips ? "map.fill" : "map")
                }
                .tag(Tab.trips)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selection == .profile ? "person.fill" : "person")
                }
                .tag(Tab.profile)
        }
        .tint(AppColor.primary)
        .environmentObject(store)
        .overlay {
            if showWelcome {
                WelcomeDialog(isPresented: $showWelcome)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showWelcome)
    }
}
