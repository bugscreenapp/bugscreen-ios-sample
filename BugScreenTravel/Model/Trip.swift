import Foundation

/// One day of a trip itinerary.
struct TripDay: Identifiable, Hashable {
    let label: String
    let title: String
    let items: [String]

    var id: String { label + "|" + title }
}

/// A planned itinerary stringing together one or more destinations.
struct Trip: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let summary: String
    let destinationIds: [String]
    let days: [TripDay]
}
