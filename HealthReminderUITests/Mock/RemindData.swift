import Foundation
@testable import enum HealthReminder.RemindType
@testable import enum HealthReminder.RemindsPriority

enum RemindDataTest {
    
    static let title = "Test remind"
    static let category = RemindType.drinkWater
    static let priority = RemindsPriority.general
    static let notificationInterval = 1
    static let createdAt: Date = .now
}
