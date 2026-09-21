import Foundation

struct PendingSession: Codable {
    let startedAt: Date
    let duration: OutingDuration
}

enum PendingSessionStore {
    private static let key = "pocketAnchor.pendingSession"

    static func save(_ session: PendingSession) {
        guard let data = try? JSONEncoder().encode(session) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func load() -> PendingSession? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(PendingSession.self, from: data)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
