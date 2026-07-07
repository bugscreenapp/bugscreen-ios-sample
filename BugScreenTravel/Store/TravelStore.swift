import SwiftUI

/// App-scoped state over the static sample data. The only mutable state is the set of saved
/// destination ids (seeded to Amalfi + Banff, in-memory, resets on relaunch) — everything else
/// is static. Ported from the Android sample's `TravelViewModel` + `TravelRepository`.
@MainActor
final class TravelStore: ObservableObject {
    let destinations = SampleData.destinations
    let trips = SampleData.trips
    let currentUser = SampleData.currentUser

    @Published private(set) var savedIds: Set<String> = ["amalfi", "banff"]

    var savedDestinations: [Destination] {
        destinations.filter { savedIds.contains($0.id) }
    }

    func isSaved(_ destination: Destination) -> Bool {
        savedIds.contains(destination.id)
    }

    func toggleSaved(_ destination: Destination) {
        if savedIds.contains(destination.id) {
            savedIds.remove(destination.id)
        } else {
            savedIds.insert(destination.id)
        }
        // (4) Breadcrumb — logged into the report's context trail.
        BugScreen.saveToggled(id: destination.id, saved: savedIds.contains(destination.id))
    }

    func destination(id: String) -> Destination? {
        destinations.first { $0.id == id }
    }

    func trip(id: String) -> Trip? {
        trips.first { $0.id == id }
    }
}
