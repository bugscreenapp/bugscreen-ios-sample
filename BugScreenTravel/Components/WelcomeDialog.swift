import SwiftUI

/// First-launch welcome dialog (ported from `WelcomeDialog.kt`). Presented as an overlay so it
/// floats above the whole tab scaffold. Points testers at the headline flow: screenshot → report.
struct WelcomeDialog: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 42))
                    .foregroundStyle(AppColor.primary)

                Text("Welcome to BugScreen Travel")
                    .textStyle(.headlineSmall)
                    .foregroundStyle(AppColor.onSurface)
                    .multilineTextAlignment(.center)

                Text("A sample travel app demoing BugScreen. Take a screenshot anywhere to report a bug — the report screen opens by itself.")
                    .textStyle(.bodyMedium)
                    .foregroundStyle(AppColor.onSurfaceVariant)
                    .multilineTextAlignment(.center)

                Button {
                    isPresented = false
                } label: {
                    Text("Got it")
                        .textStyle(.labelLarge)
                        .foregroundStyle(AppColor.onPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppColor.primary, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(24)
            .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .padding(32)
        }
    }
}
