import SwiftUI

/// Small overlay pieces shared across cards and detail screens. Ported from the Android sample's
/// `Components.kt`. The consistent look: a translucent black circle/capsule with white/gold/coral
/// content, so it reads on top of any hero gradient.

/// A 40pt circular save toggle. Filled coral heart when saved, white outline when not.
struct SaveButton: View {
    let isSaved: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSaved ? "heart.fill" : "heart")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(isSaved ? AppColor.heart : .white)
                .frame(width: 40, height: 40)
                .background(AppColor.scrim, in: Circle())
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isSaved ? "Remove from saved" : "Save")
    }
}

/// A rating capsule: gold star + one-decimal rating.
struct RatingPill: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 11))
                .foregroundStyle(AppColor.ratingStar)
            Text(String(format: "%.1f", rating))
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(AppColor.scrim, in: Capsule())
    }
}

/// A wrapping "highlight" chip in the secondary container colour.
struct HighlightChip: View {
    let text: String

    var body: some View {
        Text(text)
            .textStyle(.labelMedium)
            .foregroundStyle(AppColor.onSecondaryContainer)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(AppColor.secondaryContainer, in: Capsule())
    }
}

/// A section title with an optional subtitle.
struct SectionHeader: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .textStyle(.titleLarge)
                .foregroundStyle(AppColor.onBackground)
            if let subtitle {
                Text(subtitle)
                    .textStyle(.bodyMedium)
                    .foregroundStyle(AppColor.onSurfaceVariant)
            }
        }
    }
}

/// A centered value-over-label stat, used in the profile stats card.
struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .textStyle(.titleLarge)
                .foregroundStyle(AppColor.onSurface)
            Text(label)
                .textStyle(.labelMedium)
                .foregroundStyle(AppColor.onSurfaceVariant)
        }
    }
}
