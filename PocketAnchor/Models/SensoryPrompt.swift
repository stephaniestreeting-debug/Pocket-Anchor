import Foundation

enum NoticeCategory: String, CaseIterable, Identifiable {
    case nature
    case texture
    case life
    case sound

    var id: Self { self }

    var label: String {
        switch self {
        case .nature: "Nature"
        case .texture: "Texture"
        case .life: "Life"
        case .sound: "Sound"
        }
    }

    var items: [String] {
        switch self {
        case .nature:
            [
                "The sun on your skin, if it's out.",
                "Light filtering through leaves.",
                "The way the air moves against you.",
                "Shadows shifting as clouds pass."
            ]
        case .texture:
            [
                "The bark of a tree.",
                "The path under your feet.",
                "A cold railing or fence.",
                "Stone, brick, or a garden wall."
            ]
        case .life:
            [
                "A dog out on its own walk.",
                "Birds crossing overhead.",
                "A butterfly or bee near a flower.",
                "Someone else out enjoying the same air."
            ]
        case .sound:
            [
                "Wind moving through leaves.",
                "Birdsong somewhere close or far.",
                "The hum of distant traffic.",
                "A stretch of real quiet."
            ]
        }
    }

    func randomItem() -> String {
        items.randomElement() ?? items[0]
    }
}
