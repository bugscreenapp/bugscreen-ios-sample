import UIKit

#if DEBUG
    import BugScreenSDK
#endif

/// The single BugScreen integration surface for the whole app.
///
/// **Why funnel everything through one type?** iOS has no separate "no-op" build of the SDK the
/// way Android ships `app.bugscreen:android` on debug and `app.bugscreen:android-no-op` on
/// release. So this file is the *only* place that imports `BugScreenSDK`, and every call is
/// wrapped in `#if DEBUG`. In release builds these methods compile down to nothing — the SDK is
/// never touched — which reproduces Android's "full SDK in debug, no-op in release, and the rest
/// of the app never branches on build type" story. Screen code just calls `BugScreen.…`.
///
/// It also mirrors the Android sample's `BugScreenBreadcrumbs` wrapper: add your own events here
/// the same way you'd add analytics.
///
/// `@MainActor` because the SDK's API is main-actor isolated; callers (the SwiftUI views, the
/// store, and `App.init` at launch) are already on the main thread.
@MainActor
enum BugScreen {

    // MARK: - (1) Initialize once at startup

    /// Starts the SDK. From here on, a screenshot taken anywhere in the app opens the bug-report
    /// screen automatically — no per-screen wiring required. Called once from `App.init`.
    static func start(apiKey: String) {
        #if DEBUG
            BugScreenSDK.configure(
                apiKey: apiKey,
                enableScreenshotDetection: true,
                debug: true
            )
        #endif
    }

    // MARK: - (3) Attach user / session context

    /// Attaches who-and-what context so it rides along with every report the user files —
    /// the same four keys the Android sample sends via `setCustomData`.
    static func identify(_ user: UserProfile, sessionId: String) {
        #if DEBUG
            BugScreenSDK.setCustomData([
                "userId": user.userId,
                "plan": user.plan,
                "homeCity": user.homeCity,
                "sessionId": sessionId,
            ])
        #endif
    }

    // MARK: - (5) Manual "Report a problem" entry point

    /// Opens the BugScreen report screen on demand. Everything else is automatic — taking a
    /// screenshot anywhere in the app opens this same screen by itself.
    static func presentReport() {
        #if DEBUG
            BugScreenSDK.presentBugReport()
        #endif
    }

    // MARK: - (4) Breadcrumbs

    /// Every log line here is attached to any bug report the user submits, giving a breadcrumb
    /// trail of what they did just before hitting a problem. Same events as the Android sample.

    static func screenViewed(_ name: String) {
        log("screen_viewed: \(name)", level: .info)
    }

    static func destinationOpened(_ id: String) {
        log("destination_opened: \(id)", level: .info)
    }

    static func tripOpened(_ id: String) {
        log("trip_opened: \(id)", level: .info)
    }

    static func saveToggled(id: String, saved: Bool) {
        log("save_toggled id=\(id) saved=\(saved)", level: .debug)
    }

    // MARK: - Internal

    /// A build-type-agnostic mirror of the SDK's log levels so the app never imports
    /// `BugScreenSDK.LogLevel` outside this file (keeps the `#if DEBUG` seam here alone).
    private enum Level {
        case info
        case debug
    }

    private static func log(_ message: String, level: Level) {
        #if DEBUG
            let sdkLevel: LogLevel
            switch level {
            case .info: sdkLevel = .info
            case .debug: sdkLevel = .debug
            }
            BugScreenSDK.log(message, level: sdkLevel)
        #endif
    }
}
