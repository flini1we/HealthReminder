import Foundation
@testable import enum HealthReminder.RemindType
@testable import enum HealthReminder.RemindsPriority

enum RemintDataTest {
    
    static let title = "Test remind"
    static let category = RemindType.drinkWater
    static let priority = RemindsPriority.general
    static let notificationInterval = 1
    static let createdAt = "2025-06-15"
}
