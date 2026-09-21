import SwiftUI
import UIKit

enum Theme {
    // Adaptive: these genuinely change between light and dark mode.
    static let paper = adaptive(light: (0xF6, 0xF1, 0xE7), dark: (0x1E, 0x1B, 0x17))
    static let charcoal = adaptive(light: (0x2A, 0x28, 0x23), dark: (0xED, 0xE7, 0xDA))
    static let softInk = adaptive(light: (0x6B, 0x66, 0x5A), dark: (0xA8, 0xA0, 0x93))
    static let forest = adaptive(light: (0x3E, 0x6B, 0x4E), dark: (0x5C, 0x92, 0x70))
    static let clay = adaptive(light: (0xC1, 0x66, 0x3F), dark: (0xD9, 0x83, 0x5B))
    static let stone = adaptive(light: (0xA7, 0xB0, 0xAC), dark: (0x72, 0x6D, 0x63))

    // Fixed: text/icons drawn on a filled accent background (the forest
    // button fill, selected pills) - always light, regardless of mode,
    // since the fill itself stays a saturated color in both modes.
    static let cream = Color(red: 0xF6 / 255, green: 0xF1 / 255, blue: 0xE7 / 255)

    // Fixed: moss reads primarily against the deliberately-fixed
    // pocketBlack screen (see below), so it doesn't adapt with the rest
    // of the palette - it was already chosen to work against near-black.
    static let moss = Color(red: 0x8C / 255, green: 0x9A / 255, blue: 0x7B / 255)

    // Fixed: the Pocket screen is intentionally near-black regardless of
    // system appearance - it's the "phone looks off" moment, not a
    // reflection of the user's light/dark preference.
    static let pocketBlack = Color(red: 0x0D / 255, green: 0x0E / 255, blue: 0x0C / 255)

    private static func adaptive(light: (Int, Int, Int), dark: (Int, Int, Int)) -> Color {
        Color(UIColor { traitCollection in
            let (r, g, b) = traitCollection.userInterfaceStyle == .dark ? dark : light
            return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
        })
    }
}
