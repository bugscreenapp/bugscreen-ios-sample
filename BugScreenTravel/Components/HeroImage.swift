import SwiftUI

/// The procedural "photo" for a destination — the app's entire imagery system, ported from the
/// Android sample's `HeroImage.kt`. No bitmaps ship: each hero is a diagonal brand gradient keyed
/// to the destination kind, with one large translucent glyph bleeding off the bottom-trailing
/// corner. Callers set a frame and clip to their card shape.
struct HeroImage: View {
    let kind: DestinationKind
    var showGlyph = true

    var body: some View {
        let style = HeroImage.style(for: kind)
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                colors: [style.start, style.end],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            if showGlyph {
                Image(systemName: style.symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .foregroundStyle(.white.opacity(0.16))
                    .offset(x: 28, y: 28)
            }
        }
        .clipped()
    }

    struct Style {
        let start: Color
        let end: Color
        let symbol: String
    }

    /// Per-kind gradient + glyph table (hex pairs and glyphs mirror `HeroImage.kt`).
    static func style(for kind: DestinationKind) -> Style {
        switch kind {
        case .beach:
            return Style(start: Color(hex: 0x16A3B0), end: Color(hex: 0x0E7490), symbol: "beach.umbrella")
        case .island:
            return Style(start: Color(hex: 0x0EA5A5), end: Color(hex: 0x2563A6), symbol: "sailboat")
        case .mountain:
            return Style(start: Color(hex: 0x4B6CB7), end: Color(hex: 0x182848), symbol: "mountain.2")
        case .city:
            return Style(start: Color(hex: 0x7B2A86), end: Color(hex: 0xB5307E), symbol: "building.2")
        case .forest:
            return Style(start: Color(hex: 0x2E7D5B), end: Color(hex: 0x14532D), symbol: "tree")
        case .desert:
            return Style(start: Color(hex: 0xF2683C), end: Color(hex: 0xC2410C), symbol: "sun.max")
        case .lake:
            return Style(start: Color(hex: 0x1D8FA8), end: Color(hex: 0x0F5C7A), symbol: "water.waves")
        case .countryside:
            return Style(start: Color(hex: 0x8FA33A), end: Color(hex: 0xB8860B), symbol: "leaf")
        }
    }
}
