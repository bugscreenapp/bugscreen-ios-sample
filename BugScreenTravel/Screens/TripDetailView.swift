import SwiftUI

/// Trip itinerary detail: a real nav bar (title + back), a header, and a timeline of day rows.
/// Ported from `TripDetailScreen.kt`.
struct TripDetailView: View {
    let trip: Trip

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(trip.subtitle)
                        .textStyle(.labelLarge)
                        .foregroundStyle(AppColor.primary)
                    Text(trip.summary)
                        .textStyle(.bodyLarge)
                        .foregroundStyle(AppColor.onSurfaceVariant)
                }
                .padding(.bottom, 12)

                ForEach(trip.days) { day in
                    DayRow(day: day)
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.background)
        .navigationTitle(trip.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { BugScreen.tripOpened(trip.id) }
    }
}

/// One day of the itinerary: a numbered badge and a bulleted list of the day's items.
private struct DayRow: View {
    let day: TripDay

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(dayNumber)
                .textStyle(.titleMedium)
                .foregroundStyle(AppColor.onPrimaryContainer)
                .frame(width: 44, height: 44)
                .background(AppColor.primaryContainer, in: Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text(day.label)
                    .textStyle(.labelMedium)
                    .foregroundStyle(AppColor.onSurfaceVariant)
                Text(day.title)
                    .textStyle(.titleMedium)
                    .foregroundStyle(AppColor.onBackground)

                ForEach(day.items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(AppColor.secondary)
                            .frame(width: 5, height: 5)
                            .padding(.top, 7)
                        Text(item)
                            .textStyle(.bodyMedium)
                            .foregroundStyle(AppColor.onSurfaceVariant)
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }

    /// "Day 1–2" → "1", "Day 3" → "3".
    private var dayNumber: String {
        var value = day.label
        if value.hasPrefix("Day ") { value.removeFirst(4) }
        if let dash = value.firstIndex(where: { $0 == "–" || $0 == "-" }) {
            value = String(value[..<dash])
        }
        return value.trimmingCharacters(in: .whitespaces)
    }
}
