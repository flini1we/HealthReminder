import Foundation

final class RemindBuilder {
    
    private var remind = Remind.getEmpty()
    
    func title(_ title: String) -> Self {
        remind.setTitle(title)
        return self
    }
    
    func category(_ category: RemindType) -> Self {
        remind.setCategory(category)
        return self
    }
    
    func priority(_ priority: RemindsPriority) -> Self {
        remind.setPriority(priority)
        return self
    }
    
    func notificationInterval(_ interval: Int) -> Self {
        switch interval {
        case 1...24:
            remind.setNotificationInterval(interval)
        case ...0:
            remind.setNotificationInterval(1)
        default:
            remind.setNotificationInterval(24)
        }
        return self
    }
    
    func createdAt(_ created: Date) -> Self {
        remind.setCreatedAt(created)
        return self
    }
    
    func build() -> Remind {
        return remind
    }
    
    func reset() -> Self {
        remind = Remind.getEmpty()
        return self
    }
}
