import SwiftUI
import SwiftData

@main
struct PocketAnchorApp: App {
    var body: some Scene {
        WindowGroup {
            RootFlowView()
        }
        .modelContainer(for: OutingRecord.self)
    }
}
