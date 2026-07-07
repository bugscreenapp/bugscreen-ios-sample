import SwiftUI
import UIKit

extension Color {
    /// Solid color from a 24-bit RGB hex, e.g. `Color(hex: 0x0F766E)`.
    init(hex: UInt32) {
        self.init(uiColor: UIColor(hex: hex))
    }

    /// A dynamic color that resolves to `light` or `dark` per the current interface style —
    /// the SwiftUI equivalent of Android's separate light/dark `ColorScheme`s.
    init(light: UInt32, dark: UInt32) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
    }
}

extension UIColor {
    convenience init(hex: UInt32) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >> 8) & 0xFF) / 255
        let b = CGFloat(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

/// Material-3-style role palette, ported from the Android sample's `Color.kt`
/// (ocean teal + sunset coral over a sandy neutral; dynamic color deliberately off).
enum AppColor {
    static let primary = Color(light: 0x0F766E, dark: 0x6FD8CC)
    static let onPrimary = Color(light: 0xFFFFFF, dark: 0x003731)
    static let primaryContainer = Color(light: 0xA7F3E9, dark: 0x005047)
    static let onPrimaryContainer = Color(light: 0x00201C, dark: 0xA7F3E9)

    static let secondary = Color(light: 0xE05D3C, dark: 0xFFB59D)
    static let onSecondary = Color(light: 0xFFFFFF, dark: 0x5C1900)
    static let secondaryContainer = Color(light: 0xFFDBCF, dark: 0x7C2D12)
    static let onSecondaryContainer = Color(light: 0x3A0B00, dark: 0xFFDBCF)

    static let tertiary = Color(light: 0xC98A20, dark: 0xEEC169)
    static let onTertiary = Color(light: 0xFFFFFF, dark: 0x442B00)
    static let tertiaryContainer = Color(light: 0xFCE6BF, dark: 0x614000)
    static let onTertiaryContainer = Color(light: 0x291800, dark: 0xFCE6BF)

    static let background = Color(light: 0xFBF8F3, dark: 0x0F1311)
    static let onBackground = Color(light: 0x1B1C18, dark: 0xE3E3DC)
    static let surface = Color(light: 0xFFFFFF, dark: 0x171B18)
    static let onSurface = Color(light: 0x1B1C18, dark: 0xE3E3DC)
    static let surfaceVariant = Color(light: 0xECE6DC, dark: 0x43483F)
    static let onSurfaceVariant = Color(light: 0x4B4740, dark: 0xC7C7BB)

    static let outline = Color(light: 0x7C786F, dark: 0x8D9286)
    static let outlineVariant = Color(light: 0xD5CFC4, dark: 0x43483F)
    static let error = Color(light: 0xBA1A1A, dark: 0xFFB4AB)
    static let onError = Color(light: 0xFFFFFF, dark: 0x690005)

    // Fixed overlay colors used on top of hero imagery (constant across light/dark).
    static let heart = Color(hex: 0xFF5A5F)
    static let ratingStar = Color(hex: 0xFFC531)
    static let scrim = Color.black.opacity(0.32)
}
