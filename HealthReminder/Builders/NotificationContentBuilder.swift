import UserNotifications

final class NotificationContentBuilder {
    
    private let notificaitonContent = UNMutableNotificationContent()
    
    func title(_ title: String) -> Self {
        notificaitonContent.title = title
        return self
    }
    
    func body(_ body: String) -> Self {
        notificaitonContent.body = body
        return self
    }
    
    func sound(_ sound: UNNotificationSound) -> Self {
        notificaitonContent.sound = sound
        return self
    }
    
    func categoryIdentifier(_ id: String) -> Self {
        notificaitonContent.categoryIdentifier = id
        return self
    }
    
    func badge(_ number: Int) -> Self {
        notificaitonContent.badge = NSNumber(value: number)
        return self
    }
    
    func userInfo(_ info: [String: Any]) -> Self {
        notificaitonContent.userInfo = info
        return self
    }
    
    func build() -> UNMutableNotificationContent {
        return notificaitonContent
    }
}
