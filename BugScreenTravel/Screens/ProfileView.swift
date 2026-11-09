import SwiftUI

/// Account details, help, and BugScreen capture controls.
struct ProfileView: View {
    @EnvironmentObject private var store: TravelStore
    @State private var showRecordingStatus = false
    @State private var recordingStatus = ""

    private var user: UserProfile { store.currentUser }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                statsCard
                settingsSection
                helpSection
                if BugScreen.captureControlsAvailable {
                    captureSection
                }
                aboutSection
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .background(AppColor.background)
        .onAppear { BugScreen.screenViewed("profile") }
        .alert("Recording status", isPresented: $showRecordingStatus) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(recordingStatus)
        }
    }

    // MARK: Account header

    private var header: some View {
        VStack(spacing: 8) {
            Text(initials)
                .textStyle(.headlineMedium)
                .foregroundStyle(AppColor.onPrimaryContainer)
                .frame(width: 84, height: 84)
                .background(AppColor.primaryContainer, in: Circle())
            Text(user.displayName)
                .textStyle(.headlineSmall)
                .foregroundStyle(AppColor.onBackground)
                .padding(.top, 4)
            Text(user.email)
                .textStyle(.bodyMedium)
                .foregroundStyle(AppColor.onSurfaceVariant)
            planBadge
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
    }

    private var planBadge: some View {
        Text(user.plan.replacingOccurrences(of: "_", with: " ").uppercased())
            .textStyle(.labelMedium)
            .foregroundStyle(AppColor.onTertiaryContainer)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(AppColor.tertiaryContainer, in: Capsule())
    }

    // MARK: Stats

    private var statsCard: some View {
        HStack {
            StatItem(value: "\(user.tripsPlanned)", label: "Trips")
            Spacer()
            StatItem(value: "\(user.countriesVisited)", label: "Countries")
            Spacer()
            StatItem(value: user.memberSince, label: "Member since")
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColor.outlineVariant, lineWidth: 1)
        )
    }

    // MARK: Settings groups

    private var settingsSection: some View {
        SettingsGroup(title: "Settings") {
            SettingsRow(icon: "bell", title: "Notifications", subtitle: "Trip reminders and deals")
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "moon", title: "Appearance", subtitle: "Follows your system theme")
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "lock", title: "Privacy", subtitle: "Manage your data")
        }
    }

    private var helpSection: some View {
        SettingsGroup(title: "Help") {
            // (5) Open the reporter directly from the app's Help section.
            SettingsRow(
                icon: "ladybug",
                title: "Report a problem",
                subtitle: "Opens the BugScreen report form",
                action: { BugScreen.presentReport() }
            )
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(
                icon: "bubble.left",
                title: "Send feedback",
                subtitle: "Tell us what you think",
                action: { BugScreen.presentReport() }
            )
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(
                icon: "camera",
                title: "Tip: take a screenshot",
                subtitle: "Screenshot anywhere to report a bug instantly"
            )
        }
    }

    private var captureSection: some View {
        SettingsGroup(title: "BugScreen capture controls") {
            SettingsRow(icon: "ladybug", title: "Show floating button", subtitle: "Open the SDK menu from any screen") {
                BugScreen.setFloatingButtonVisible(true)
            }
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "ladybug", title: "Hide floating button", subtitle: "Remove the floating menu") {
                BugScreen.setFloatingButtonVisible(false)
            }
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "video", title: "Start recent recording", subtitle: "Keep up to 15 seconds after system consent") {
                BugScreen.setRecordingEnabled(true)
            }
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "stop.circle", title: "Stop recent recording", subtitle: "Stop capture and clear recent history") {
                BugScreen.setRecordingEnabled(false)
            }
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "info.circle", title: "Check recording status", subtitle: "Read the current state from the SDK") {
                recordingStatus = BugScreen.recordingStatus()
                showRecordingStatus = true
            }
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "bell", title: "Show report notification", subtitle: "Allow notifications when asked") {
                BugScreen.setReportNotificationVisible(true)
            }
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "bell.slash", title: "Hide report notification", subtitle: "Remove the reporting shortcut") {
                BugScreen.setReportNotificationVisible(false)
            }
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "iphone", title: "Enable shake-to-report", subtitle: "Shake while the app is open to report") {
                BugScreen.setShakeDetectionEnabled(true)
            }
            Divider().overlay(AppColor.outlineVariant)
            SettingsRow(icon: "iphone", title: "Disable shake-to-report", subtitle: "Turn off the motion shortcut") {
                BugScreen.setShakeDetectionEnabled(false)
            }
        }
    }

    private var aboutSection: some View {
        SettingsGroup(title: "About") {
            SettingsRow(
                icon: "info.circle",
                title: "BugScreen Travel",
                subtitle: "Version 1.0 · BugScreen example app"
            )
        }
    }

    private var initials: String {
        user.displayName
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }
}

// MARK: - Settings building blocks

private struct SettingsGroup<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .textStyle(.titleMedium)
                .foregroundStyle(AppColor.onSurfaceVariant)
                .padding(.leading, 4)
            VStack(spacing: 0) { content }
                .background(AppColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppColor.outlineVariant, lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var action: (() -> Void)?

    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(AppColor.primary)
                    .frame(width: 26)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .textStyle(.titleMedium)
                        .foregroundStyle(AppColor.onSurface)
                    Text(subtitle)
                        .textStyle(.bodyMedium)
                        .foregroundStyle(AppColor.onSurfaceVariant)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}
