import Foundation

enum OutingDuration: String, CaseIterable, Identifiable, Codable {
    case doorway
    case nearby
    case block
    case wander
    case open

    var id: Self { self }

    var label: String {
        switch self {
        case .doorway: "2 min"
        case .nearby: "5 min"
        case .block: "10 min"
        case .wander: "20 min"
        case .open: "Open"
        }
    }

    var subtitle: String {
        switch self {
        case .doorway: "Just the doorway"
        case .nearby: "Just the garden, porch, or step"
        case .block: "Around the block"
        case .wander: "A proper wander"
        case .open: "However long feels right"
        }
    }

    var reassurance: String? {
        switch self {
        case .doorway: "Some days, the doorway is the whole thing."
        case .nearby: "Staying close to home counts just as much as going further."
        case .block, .wander, .open: nil
        }
    }

    /// Roughly how long this outing is meant to last, used only to place
    /// the halfway chime. `nil` for `.open`, which has no fixed length.
    var approximateSeconds: TimeInterval? {
        switch self {
        case .doorway: 120
        case .nearby: 300
        case .block: 600
        case .wander: 1200
        case .open: nil
        }
    }
}
