import SwiftUI

/// App entry point — the iOS equivalent of Android's `TravelApp` (`Application`). This is where a
/// real app initializes BugScreen: once, at startup.
///
/// Because every BugScreen call goes through the `BugScreen` facade (which no-ops in release
/// builds), these calls do nothing in a release build — there's no need to guard them behind a
/// build-type check.
@main
struct BugScreenTravelApp: App {

    init() {
        // (1) Start the SDK. From here on, a screenshot taken anywhere in the app opens the
        //     bug-report screen automatically — no per-screen wiring required. The key comes
        //     from Config/Secrets.xcconfig via Info.plist; "" is fine (you just can't upload).
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "BugScreenAPIKey") as? String ?? ""
        BugScreen.start(apiKey: apiKey)

        // (3) Attach who-and-what context so it rides along with every report the user files.
        BugScreen.identify(SampleData.currentUser, sessionId: UUID().uuidString)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
