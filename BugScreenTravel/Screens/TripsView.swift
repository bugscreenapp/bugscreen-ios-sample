import SwiftUI

/// The trips list — one horizontal card per planned itinerary. Ported from `TripsScreen.kt`.
struct TripsView: View {
    @EnvironmentObject private var store: TravelStore
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Trips")
                            .textStyle(.displaySmall)
                            .foregroundStyle(AppColor.onBackground)
                        Text("Your planned itineraries")
                            .textStyle(.bodyLarge)
                            .foregroundStyle(AppColor.onSurfaceVariant)
                    }
                    .padding(.top, 12)

                    ForEach(store.trips) { trip in
                        TripCard(
                            trip: trip,
                            leadKind: leadKind(for: trip),
                            onOpen: { path.append(trip) }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColor.background)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Trip.self) { trip in
                TripDetailView(trip: trip)
            }
        }
        .onAppear { BugScreen.screenViewed("trips") }
    }

    private func leadKind(for trip: Trip) -> DestinationKind {
        trip.destinationIds.first.flatMap { store.destination(id: $0)?.kind } ?? .city
    }
}
