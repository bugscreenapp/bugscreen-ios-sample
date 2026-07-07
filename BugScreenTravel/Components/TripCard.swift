import SwiftUI

/// Horizontal trip row: a small square hero (using the trip's first destination kind), the trip
/// text, and a trailing chevron. Ported from `TripsScreen.kt`'s `TripCard`.
struct TripCard: View {
    let trip: Trip
    let leadKind: DestinationKind
    let onOpen: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            HeroImage(kind: leadKind)
                .frame(width: 96, height: 96)

            VStack(alignment: .leading, spacing: 3) {
                Text(trip.title)
                    .textStyle(.titleLarge)
                    .foregroundStyle(AppColor.onSurface)
                Text(trip.subtitle)
                    .textStyle(.labelMedium)
                    .foregroundStyle(AppColor.primary)
                Text(trip.summary)
                    .textStyle(.bodyMedium)
                    .foregroundStyle(AppColor.onSurfaceVariant)
                    .lineLimit(2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColor.onSurfaceVariant)
                .padding(.trailing, 14)
        }
        .frame(maxWidth: .infinity)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColor.outlineVariant, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture(perform: onOpen)
    }
}
