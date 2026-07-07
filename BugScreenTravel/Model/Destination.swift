import Foundation

/// The category of a place. Drives the procedural `HeroImage` gradient + glyph — there are no
/// bundled photos in this sample.
enum DestinationKind: String, CaseIterable, Hashable {
    case beach, island, mountain, city, forest, desert, lake, countryside
}

/// A place you can browse, open, and save. All content is static sample data.
struct Destination: Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let kind: DestinationKind
    let blurb: String
    let description: String
    let highlights: [String]
    let bestSeason: String
    let rating: Double
}
