//@testable import HealthReminder
//import XCTest
//import PushKit
//
//import XCTest
//
//final class ReminderPushNotificationUITests: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//        continueAfterFailure = false
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
//        guard let deeplink = DeeplinkRemindDetailBuilder().buildRemindDetailDeeplink(for: remind) else {
//            XCTFail("Failed to create deeplink")
//            return
//        }
//
//        let fakePushPayload = """
//        {
//            "aps": {
//                "alert": "Напоминание: \(remind.title)",
//                "sound": "default"
//            },
//            "deeplink": "\(deeplink.absoluteString)"
//        }
//        """
//        
//        let app = XCUIApplication()
//        app.launchArguments += [
//            "-UITest",
//            "-fakePushNotification",
//            fakePushPayload
//        ]
//        app.launch()
//        
//        let titleLabel = app.staticTexts[remind.title]
//        XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "RemindDetail screen did not open")
//    }
//}
