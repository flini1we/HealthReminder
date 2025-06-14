import SwiftData

@Model
class RemindModel: Identifiable {
    
    var title: String
    var category: RemindType
    var priority: RemindsPriority
    var notificationInterval: Int
    var createdAt: String
    
    init(title: String, category: RemindType, priority: RemindsPriority, notificationInterval: Int, createdAt: String) {
        self.title = title
        self.category = category
        self.priority = priority
        self.notificationInterval = notificationInterval
        self.createdAt = createdAt
    }
    
    init(from remind: Remind) {
        self.title = remind.title
        self.category = remind.category
        self.priority = remind.priority
        self.notificationInterval = remind.notificationInterval
        self.createdAt = remind.createdAt
    }
    
    func convertToRemind() -> Remind {
        Remind(
            title: self.title,
            category: self.category,
            priority: self.priority,
            notificationInterval: self.notificationInterval,
            createdAt: self.createdAt
        )
    }
}
