import XCTest
import Combine
@testable import HealthReminder

private extension String {
    
    static let testRemindTitle = "Test remind"
}

final class RemindServiceTests: XCTestCase {
    
    private var remindService: IRemindService!
    private var cancellables: Set<AnyCancellable>!
    
    private var mockPush: IPushNotificationService!
    private var mockFactory: INotificationRequestFactory!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        remindService = RemindService()
        mockPush = MockPushNotificationService()
        mockFactory = MockNotificationRequestFactory()
    }
    
    override func tearDown() {
        cancellables = nil
        remindService = nil
        super.tearDown()
    }
    
    func test_appendRemind_storesRemindAndPublishesIt() {
        let remind = Remind(
            title: RemindDataTest.title,
            category: RemindDataTest.category,
            priority: RemindDataTest.priority,
            notificationInterval: RemindDataTest.notificationInterval,
            createdAt: .now
        )
        var publishedReminds: [Remind] = []
        var newRemind: Remind?

        let prevNotification = mockPush.notificationsSent
        let prevRemindsCount = publishedReminds.count
        let expectation1 = expectation(description: "Reminds list updated")
        let expectation2 = expectation(description: "New remind published")
        let pushExpectation = expectation(description: "Push notification sent")
        
        remindService.remindsPublisher
            .sink { reminds in
                publishedReminds = reminds
                if !reminds.isEmpty { expectation1.fulfill() }
            }
            .store(in: &cancellables)

        remindService.newRemindPublisher
            .sink { remind in
                newRemind = remind
                expectation2.fulfill()
                self.mockPush
                    .presetnNotificationRequest(.init(identifier: "", content: UNNotificationContent(), trigger: nil))
                pushExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        remindService.appendRemind(remind)

        wait(for: [expectation1, expectation2, pushExpectation], timeout: 2.0)
        XCTAssertEqual(publishedReminds.count, prevRemindsCount + 1)
        XCTAssertEqual(publishedReminds.first?.title, RemindDataTest.title)
        XCTAssertEqual(newRemind?.priority, RemindDataTest.priority)
        XCTAssertEqual(prevNotification + 1, mockPush.notificationsSent)
    }
}
