import SwiftUI
import UIKit

extension Font {
    /// A system font at a custom point size that still scales with the
    /// user's Dynamic Type text-size setting (unlike `.system(size:)`,
    /// which is a fixed point size regardless of accessibility settings).
    static func scalable(_ size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        var uiWeight: UIFont.Weight = .regular
        switch weight {
        case .black: uiWeight = .black
        case .heavy: uiWeight = .heavy
        case .bold: uiWeight = .bold
        case .semibold: uiWeight = .semibold
        case .medium: uiWeight = .medium
        case .light: uiWeight = .light
        case .thin: uiWeight = .thin
        case .ultraLight: uiWeight = .ultraLight
        default: uiWeight = .regular
        }

        var baseFont = UIFont.systemFont(ofSize: size, weight: uiWeight)
        if design == .serif, let serifDescriptor = baseFont.fontDescriptor.withDesign(.serif) {
            baseFont = UIFont(descriptor: serifDescriptor, size: size)
        }

        let scaled = UIFontMetrics.default.scaledFont(for: baseFont)
        return Font(scaled)
    }
}
