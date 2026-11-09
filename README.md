# BugScreen — iOS integration example

A reference for wiring the [BugScreen](https://bugscreen.app) bug-reporting SDK into an iOS app.
If you're evaluating BugScreen or setting it up for the first time, this repo shows every
integration point in a working app. Use the integration points below to wire up the SDK.

A tester takes a screenshot anywhere in the app and the report screen opens. Reports include
device info, your custom data, and a breadcrumb log. Testers never leave the app.

The SDK is wired into a small but complete travel app (SwiftUI, iOS 16+), so you can see it working
in a real navigation stack. [More on the demo app below.](#the-demo-app) This is the iOS twin of the
[Android sample](https://github.com/bugscreenapp/bugscreen-android-sample).

> **See what a report looks like** →
> [Sample bug report](https://github.com/bugscreenapp/bugscreen-ios-sample/issues/1) is a real
> report filed from this app. It shows everything a tester's screenshot delivers: the annotated
> screenshot, the reporter's type/severity classification, full device and OS metadata, and the
> custom data this app attaches (`userId`, `plan`, `homeCity`, `sessionId`). Reports can land in
> GitHub Issues, Jira, ClickUp, Slack, and more.

## The integration

Everything BugScreen-related lives in a handful of clearly-commented spots. All SDK calls are
funnelled through one facade — [`BugScreen.swift`](BugScreenTravel/BugScreen/BugScreen.swift) — so
the rest of the app reads like a normal app and never imports the SDK directly.

| # | What | Where |
|---|------|-------|
| 1 | Initialize once at startup | [`BugScreenTravelApp.swift`](BugScreenTravel/App/BugScreenTravelApp.swift) → `BugScreen.start(apiKey:)` (`BugScreenSDK.configure`) |
| 2 | Allow reading the OS screenshot | [`Info.plist`](Info.plist) → `NSPhotoLibraryUsageDescription` |
| 3 | Attach user / session context | [`BugScreenTravelApp.swift`](BugScreenTravel/App/BugScreenTravelApp.swift) → `BugScreen.identify(_:sessionId:)` (`BugScreenSDK.setCustomData`) |
| 4 | Log breadcrumbs at meaningful events | [`BugScreen.swift`](BugScreenTravel/BugScreen/BugScreen.swift) (`BugScreenSDK.log`) — called from each screen's `.onAppear` and the save action |
| 5 | Manual "Report a problem" entry point | [`ProfileView.swift`](BugScreenTravel/Screens/ProfileView.swift) → `BugScreen.presentReport()` (`BugScreenSDK.presentBugReport`) |
| 6 | Exercise capture controls | [`ProfileView.swift`](BugScreenTravel/Screens/ProfileView.swift) → [`BugScreen.swift`](BugScreenTravel/BugScreen/BugScreen.swift) |

Automatic screenshot detection needs no wiring beyond step 1; it's on by default. When a tester
takes a screenshot, the SDK reads it from the Photos library and opens the report screen — which is
why step 2 (the Photos usage string) exists. The SDK drives the Photos permission prompt itself at
capture time; there is no runtime-permission code to write.

### Dependency setup

The SDK is added as a Swift Package. `BugScreenTravel.xcodeproj` already references it:

```
https://github.com/bugscreenapp/bugscreen-ios   —   Up to Next Major, from 1.9.0
```

Xcode resolves and builds it on first open; no manual step needed.

**Debug vs. release.** BugScreen is a dev/QA tool, so it shouldn't ship to production users. Every
SDK call goes through the one facade file
[`BugScreen.swift`](BugScreenTravel/BugScreen/BugScreen.swift) — the *only* file that imports
`BugScreenSDK` — and each call is wrapped in `#if DEBUG`. In release builds those calls compile
down to nothing: the SDK is never touched, no bug-reporting code runs for production users, and the
rest of the app never branches on build type.

### API key

The API key is read from a **git-ignored** `Config/Secrets.xcconfig`, surfaced into `Info.plist`
(`BugScreenAPIKey`) and read at launch — so no key is ever committed.

```bash
cp Config/Secrets.xcconfig.sample Config/Secrets.xcconfig
# then edit Config/Secrets.xcconfig:
#   BUGSCREEN_API_KEY = fb_your_api_key_here
```

You can leave the key blank to build and browse the Travel app. Reporting needs a valid app key
to load report settings and upload reports. With a blank or invalid key, the reporter shows a
settings-loading error.

## Run it

1. Open `BugScreenTravel.xcodeproj` in Xcode (latest stable). Let it resolve the Swift Package.
2. Add your API key for reporting (see above). Paste your key from the
   [BugScreen console](https://bugscreen.app).
3. Pick an iOS 16+ simulator (or a device) and press **⌘R**.
4. Try the headline flow: open the app and take a screenshot. In the Simulator that's
   **Device ▸ Trigger Screenshot** (⌘S); on a device it's the usual hardware buttons. The report
   screen opens by itself. You can also open it manually from **Profile ▸ Report a problem**.

> **Deployment target:** iOS 16.0 (the app uses `NavigationStack` and the `Layout` protocol). The
> SDK itself supports iOS 15+.

## Try the BugScreen 1.9 controls

In a Debug build, open **Profile → BugScreen capture controls**. Use a physical device to try
shake-to-report and recording.

- **Floating button.** Tap the floating BugScreen button to open its menu. Use **Hide floating
  button** and **Show floating button** to change its visibility.
- **Recent recording.** Select **Start recent recording**, then approve the system prompt.
  **Check recording status** reads the current state from the SDK. Reproduce the issue and open
  the reporter while recording to attach up to 15 seconds of recent video. **Stop recent
  recording** clears the rolling buffer.
- **Report notification.** Select **Show report notification** and allow notifications when
  asked. Open Notification Center over the app and tap the BugScreen notification. Use **Hide
  report notification** to remove the shortcut.
- **Shake-to-report.** Select **Enable shake-to-report**, then deliberately shake the device
  while the app is open. **Disable shake-to-report** turns the shortcut off.

[`BugScreen.swift`](BugScreenTravel/BugScreen/BugScreen.swift) opts in to attaching available
app-process logs. Keep secrets and personal data out of logs when testing reports.

## The demo app

**BugScreen Travel** is a small travel-discovery app that gives the SDK a place to live. Browse
destinations, save favourites, and open a trip itinerary, plus a manual "Report a problem" entry
point in the profile. Built with SwiftUI (`NavigationStack` + `TabView`). All content is bundled
and static, so no backend, accounts, or network are needed to run it.

| Explore | Destination | Report (automatic) | Profile |
|---|---|---|---|
| Feed of destinations | Photo, highlights, save | Opens on screenshot | Manual "Report a problem" |

### Project layout

```
BugScreenTravel/
  App/BugScreenTravelApp.swift     # @main App — SDK init + custom data   (integration #1, #3)
  BugScreen/BugScreen.swift        # the one SDK facade — #if DEBUG        (integration #4)
  Model/                           # Destination, Trip, UserProfile, SampleData (static)
  Store/TravelStore.swift          # app-scoped state over the sample data
  Navigation/RootView.swift        # TabView + per-tab NavigationStacks + welcome dialog
  Theme/                           # Material-3-style palette + type scale (light/dark)
  Components/                      # HeroImage (procedural gradients), cards, chrome, FlowLayout
  Screens/                         # Explore / DestinationDetail / Saved / Trips / TripDetail / Profile
  Resources/Assets.xcassets        # AppIcon + AccentColor
Config/                            # Config.xcconfig (+ git-ignored Secrets.xcconfig)
Info.plist                         # Photos usage string (#2) + BugScreenAPIKey
```

### Notes & limitations

- **Static data.** Destinations, trips, and the user are hard-coded in
  [`SampleData.swift`](BugScreenTravel/Model/SampleData.swift).
- **No persistence.** Saved destinations live in memory (seeded to Amalfi + Banff) and reset when
  the app is relaunched.
- **No bundled photos.** Destination "images" are gradients generated from each place's category
  (see [`HeroImage.swift`](BugScreenTravel/Components/HeroImage.swift)), which keeps the repo small
  and free of image licensing.
- **Reporting needs a real key.** A blank or invalid `BUGSCREEN_API_KEY` cannot load report
  settings. Add your `fb_...` key to `Config/Secrets.xcconfig` to open the form and submit reports.
