import Foundation

struct Remind: Identifiable, Hashable, Codable {
    
    let id: UUID = .init()
    var title: String
    var category: RemindType
    var priority: RemindsPriority
    var notificationInterval: Int
    var createdAt: String
    
    static func getEmpty() -> Self {
        .init(
            title: "",
            category: .breathing,
            priority: .general,
            notificationInterval: 0,
            createdAt: ""
        )
    }
    
    mutating func setTitle(_ title: String) {
        self.title = title
    }
    
    mutating func setCategory(_ category: RemindType) {
        self.category = category
    }
    
    mutating func setPriority(_ priority: RemindsPriority) {
        self.priority = priority
    }
    
    mutating func setNotificationInterval(_ interval: Int) {
        self.notificationInterval = interval
    }
    
    mutating func setCreatedAt(_ createdAt: String) {
        self.createdAt = createdAt
    }
    
    func getTail() -> String {
        return notificationInterval == 1 ? "" : "s"
    }
    
    func getUserInfo() -> [String: Any] {
        [
            "title": self.title,
            "category": self.category.rawValue,
            "priority": self.priority.rawValue,
            "notificationInterval": self.notificationInterval,
            "createdAt": self.createdAt,
        ]
    }
}
