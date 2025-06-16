//@testable import HealthReminder
//import XCTest
//import PushKit
//
//import XCTest
//
//final class ReminderPushNotificationUITests: XCTestCase {
//    
//    let app = XCUIApplication()
//    
//    override func setUp() {
//        super.setUp()
//        continueAfterFailure = false
//        app.launch()
//    }
//
//    func testFakePushNotificationOpensRemindDetail() {
//        let remind = Remind(
//            title: RemindDataTest.title,
//            category: RemindDataTest.category,
//            priority: RemindDataTest.priority,
//            notificationInterval: RemindDataTest.notificationInterval,
//            createdAt: RemindDataTest.createdAt
//        )
//        
//        let notificationContent = NotificationContentBuilder()
//            .title(remind.title)
//            .body("Remind about \(remind.priority.embend) task")
//            .sound(.default)
//            .categoryIdentifier(remind.category.rawValue)
//            .build()
//        
//        let notificationCenter = UNUserNotificationCenter.current()
//        
//        let request = UNNotificationRequest(
//            identifier: "test-notification",
//            content: notificationContent,
//            trigger: nil
//        )
//        
//        let expectation = XCTestExpectation(description: "Notification shown")
//        notificationCenter.add(request) { error in
//            if let error = error {
//                XCTFail("Ошибка при показе уведомления: \(error.localizedDescription)")
//            }
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 5)
//    }
//}
