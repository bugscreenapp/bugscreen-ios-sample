import SwiftUI

/// Editorial, travel-magazine type scale ported from the Android sample's `Type.kt`.
/// Pairs a system font with the sample's tuned letter-spacing (tracking).
struct AppTextStyle {
    let font: Font
    let tracking: CGFloat

    static let displaySmall = AppTextStyle(font: .system(size: 34, weight: .bold), tracking: -0.5)
    static let headlineMedium = AppTextStyle(font: .system(size: 26, weight: .bold), tracking: -0.25)
    static let headlineSmall = AppTextStyle(font: .system(size: 22, weight: .semibold), tracking: 0)
    static let titleLarge = AppTextStyle(font: .system(size: 19, weight: .semibold), tracking: 0)
    static let titleMedium = AppTextStyle(font: .system(size: 16, weight: .semibold), tracking: 0)
    static let bodyLarge = AppTextStyle(font: .system(size: 16, weight: .regular), tracking: 0.15)
    static let bodyMedium = AppTextStyle(font: .system(size: 14, weight: .regular), tracking: 0.2)
    static let labelLarge = AppTextStyle(font: .system(size: 14, weight: .semibold), tracking: 0.1)
    static let labelMedium = AppTextStyle(font: .system(size: 12, weight: .medium), tracking: 0.5)
}

extension View {
    /// Applies one of the app's text styles (font + tracking).
    func textStyle(_ style: AppTextStyle) -> some View {
        font(style.font).tracking(style.tracking)
    }
}
