@testable import protocol HealthReminder.INotificationRequestFactory
@testable import struct HealthReminder.Remind

final class MockNotificationRequestFactory: INotificationRequestFactory {
    
    var didCallCreate = false
    var lastRemind: Remind?
    
    func createRemindNotificationRequest(from remind: Remind) {
        didCallCreate = true
        lastRemind = remind
    }
}
