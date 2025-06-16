import UIKit
import UserNotifications

protocol INotificationRequestFactory {
    
    func createRemindNotificationRequest(
        from remind: Remind
    )
}

final class NotificationRequestFactory: INotificationRequestFactory {
    private var notificationService: IPushNotificationService
    private var userDefaults = UserDefaults.standard
    
    init(notificationService: IPushNotificationService) {
        self.notificationService = notificationService
    }
    
    private lazy var jsonEncoder: JSONEncoder = { JSONEncoder() }()
    
    func createRemindNotificationRequest(
        from remind: Remind
    ) {
        let prevValue = userDefaults.integer(forKey: .notificationBadgesCountKey)
        userDefaults.set(prevValue + 1, forKey: .notificationBadgesCountKey)
        
        let notificationContent = NotificationContentBuilder()
            .title(remind.title)
            .body("Remind about \(remind.priority.embend) task")
            .sound(.default)
            .categoryIdentifier(remind.category.rawValue)
            .badge(prevValue + 1)
            .build()
        
        let repeatingNotificationTrigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(3600 * remind.notificationInterval),
            repeats: true
        )
        
        do {
            let remindData = try jsonEncoder.encode(remind)
            let remindDataDict = try JSONSerialization.jsonObject(with: remindData) as? [String: Any]
            notificationContent.userInfo = [String.remindHost: remindDataDict ?? []]
        } catch {
            // TODO: handle
            fatalError("")
        }
        
        let repeatingRequest = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: repeatingNotificationTrigger
        )
        
        let currentleRequest = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: nil
        )
        
        notificationService.presetnNotificationRequest(currentleRequest)
        notificationService.presetnNotificationRequest(repeatingRequest)
    }
}

private extension String {
    
    static let notificationBadgesCountKey = "notification_badges_count"
}
