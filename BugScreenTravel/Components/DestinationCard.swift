import SwiftUI

/// Full-bleed hero card for the Explore feed (ported from `DestinationCard.kt`). The whole card
/// opens the destination; the heart toggles saved without navigating.
struct DestinationCard: View {
    let destination: Destination
    let isSaved: Bool
    let onOpen: () -> Void
    let onToggleSave: () -> Void

    var body: some View {
        ZStack {
            HeroImage(kind: destination.kind)
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.55)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            RatingPill(rating: destination.rating)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(12)

            SaveButton(isSaved: isSaved, action: onToggleSave)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(12)

            VStack(alignment: .leading, spacing: 2) {
                Text(destination.country.uppercased())
                    .textStyle(.labelMedium)
                    .foregroundStyle(.white.opacity(0.85))
                Text(destination.name)
                    .textStyle(.headlineSmall)
                    .foregroundStyle(.white)
                Text(destination.blurb)
                    .textStyle(.bodyMedium)
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(18)
        }
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture(perform: onOpen)
    }
}
