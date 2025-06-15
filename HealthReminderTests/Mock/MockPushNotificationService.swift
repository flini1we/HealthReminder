import UserNotifications
@testable import protocol HealthReminder.IPushNotificationService

final class MockPushNotificationService: IPushNotificationService {
    var notificationsSent: Int = 0
    var lastNotificationRequest: UNNotificationRequest?
    
    func isNotificationGranted() async -> Bool {
        return true
    }
    
    func registerForNotification() async throws -> Bool {
        return true
    }
    
    func presetnNotificationRequest(_ request: UNNotificationRequest) {
        lastNotificationRequest = request
        notificationsSent += 1
    }
}
