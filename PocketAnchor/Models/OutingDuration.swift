import Foundation

enum OutingDuration: String, CaseIterable, Identifiable, Codable {
    case doorway
    case block
    case wander
    case open

    var id: Self { self }

    var label: String {
        switch self {
        case .doorway: "2 min"
        case .block: "10 min"
        case .wander: "20 min"
        case .open: "Open"
        }
    }

    var subtitle: String {
        switch self {
        case .doorway: "Just the doorway"
        case .block: "Around the block"
        case .wander: "A proper wander"
        case .open: "However long feels right"
        }
    }
}
