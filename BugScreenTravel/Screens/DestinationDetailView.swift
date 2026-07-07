import SwiftUI

/// Full-bleed destination detail: a 340pt hero that runs under the status bar with floating
/// back/save controls, then best-season, description, and wrapping highlight chips.
/// Ported from `DestinationDetailScreen.kt`.
struct DestinationDetailView: View {
    @EnvironmentObject private var store: TravelStore
    @Environment(\.dismiss) private var dismiss
    let destination: Destination

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroBlock

                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundStyle(AppColor.primary)
                            Text("Best time to visit · \(destination.bestSeason)")
                                .textStyle(.titleMedium)
                                .foregroundStyle(AppColor.onSurface)
                        }

                        Text(destination.description)
                            .textStyle(.bodyLarge)
                            .foregroundStyle(AppColor.onSurfaceVariant)

                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Highlights")
                            FlowLayout(spacing: 8) {
                                ForEach(destination.highlights, id: \.self) { highlight in
                                    HighlightChip(text: highlight)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
            .ignoresSafeArea(edges: .top)

            topControls
        }
        .background(AppColor.background)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { BugScreen.destinationOpened(destination.id) }
    }

    private var heroBlock: some View {
        ZStack(alignment: .bottomLeading) {
            HeroImage(kind: destination.kind)
                .frame(height: 340)
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.55)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )

            VStack(alignment: .leading, spacing: 10) {
                RatingPill(rating: destination.rating)
                Text(destination.name)
                    .textStyle(.displaySmall)
                    .foregroundStyle(.white)
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.9))
                    Text(destination.country)
                        .textStyle(.titleMedium)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding(20)
        }
        .frame(height: 340)
        .clipped()
    }

    private var topControls: some View {
        HStack {
            circleButton("chevron.left", label: "Back") { dismiss() }
            Spacer()
            SaveButton(isSaved: store.isSaved(destination)) {
                store.toggleSaved(destination)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
    }

    private func circleButton(_ systemName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(AppColor.scrim, in: Circle())
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}
