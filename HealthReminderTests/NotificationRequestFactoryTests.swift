import XCTest
@testable import HealthReminder

final class NotificationRequestFactoryTests: XCTestCase {
    
    func test_createRemindNotificationRequest_buildsCorrectUNNotificationRequest() throws {
        let mockService = MockPushNotificationService()
        let factory = NotificationRequestFactory(notificationService: mockService)

        let remind = Remind(
            title: RemintDataTest.title,
            category: RemintDataTest.category,
            priority: RemintDataTest.priority,
            notificationInterval: RemintDataTest.notificationInterval,
            createdAt: RemintDataTest.createdAt
        )
        factory.createRemindNotificationRequest(from: remind)

        guard
            let request = mockService.lastNotificationRequest
        else {
            XCTFail("No notification request created")
            return
        }

        let content = request.content
        
        XCTAssertEqual(content.title, RemintDataTest.title)
        XCTAssertEqual(content.body, "Remind about general task")
        XCTAssertEqual(content.sound, UNNotificationSound.default)
        XCTAssertEqual(content.categoryIdentifier, remind.category.rawValue)
        XCTAssertEqual(content.badge, 1)
        
        guard
            let remindDict = content.userInfo[String.remindHost] as? [String: Any]
        else {
            XCTFail("userInfo.remindHost not found or wrong type")
            return
        }

        XCTAssertEqual(remindDict["title"] as? String, RemintDataTest.title)
        XCTAssertEqual(remindDict["priority"] as? String, RemintDataTest.priority.rawValue)
        XCTAssertEqual(remindDict["category"] as? String, "\(RemintDataTest.category)")
        XCTAssertEqual(remindDict["createdAt"] as? String, RemintDataTest.createdAt)
    }
}
