import SwiftUI

/// Compact hero tile for the Saved 2-column grid (ported from `SavedScreen.kt`'s `SavedCard`).
/// The heart is always filled here; tapping it un-saves and removes the tile live.
struct SavedCard: View {
    let destination: Destination
    let onOpen: () -> Void
    let onToggleSave: () -> Void

    var body: some View {
        ZStack {
            HeroImage(kind: destination.kind)
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            SaveButton(isSaved: true, action: onToggleSave)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(8)

            VStack(alignment: .leading, spacing: 1) {
                Text(destination.name)
                    .textStyle(.titleMedium)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(destination.country)
                    .textStyle(.labelMedium)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture(perform: onOpen)
    }
}
