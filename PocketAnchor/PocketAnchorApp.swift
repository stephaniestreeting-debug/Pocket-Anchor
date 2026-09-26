import SwiftUI
import UserNotifications

/// Lets the halfway chime's banner and sound present even if the app
/// happens to still be in the foreground when it fires (default iOS
/// behavior would otherwise suppress both while the app is active).
private final class NotificationPresenter: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}

@main
struct PocketAnchorApp: App {
    private let notificationPresenter = NotificationPresenter()

    init() {
        UNUserNotificationCenter.current().delegate = notificationPresenter
    }

    var body: some Scene {
        WindowGroup {
            RootFlowView()
        }
    }
}
