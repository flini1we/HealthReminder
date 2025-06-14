import UIKit
import UserNotifications

protocol INotificationRequestFactory {
    
    func createRemindNotificationRequest(
        from remind: Remind
    )
}

final class NotificationRequestFactory: INotificationRequestFactory {
    private var notificationService: IPushNotificationService
    
    init(notificationService: IPushNotificationService) {
        self.notificationService = notificationService
    }
    
    private lazy var jsonEncoder: JSONEncoder = { JSONEncoder() }()
    
    func createRemindNotificationRequest(
        from remind: Remind
    ) {
        let notificationContent = NotificationContentBuilder()
            .title(remind.title)
            .body("Remind about \(remind.priority.embend) task")
            .sound(.default)
            .categoryIdentifier(remind.category.rawValue)
            .badge(1)
            .build()
        do {
            let remindData = try jsonEncoder.encode(remind)
            let remindDataDict = try JSONSerialization.jsonObject(with: remindData) as? [String: Any]
            notificationContent.userInfo = ["remind": remindDataDict ?? []]
        } catch {
            // TODO: handle
            fatalError("")
        }
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: nil
        )
        
        notificationService.presetnNotificationRequest(request)
    }
}
