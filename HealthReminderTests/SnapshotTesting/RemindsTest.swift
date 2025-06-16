import SnapshotTesting
import XCTest
import SwiftUI

@testable import HealthReminder

final class RemindsTest: XCTestCase {
    
    override func setUpWithError() throws {
        // isRecording = false
    }
    
    func testWithOutReminds() throws {
        let remindsController = RemindsAssembly(container: DIContainer()).resolveRemindsModule()
        
        assertSnapshot(of: remindsController, as: .image)
    }
    
    func testWithReminds() throws {
        let remindsController = RemindsAssembly(container: DIContainer()).resolveRemindsModule()
        guard let remindViewController = remindsController as? IRemindsView else {
            XCTAssertThrowsError("")
            return
        }
        remindViewController.remindsDidLoad([
            .init(title: "1", category: .breathing, priority: .daily, notificationInterval: 1, createdAt: .now),
            .init(title: "2", category: .drinkWater, priority: .general, notificationInterval: 2, createdAt: .now),
            .init(title: "3", category: .meal, priority: .important, notificationInterval: 3, createdAt: .now),
            .init(title: "4", category: .sleep, priority: .daily, notificationInterval: 4, createdAt: .now),
            .init(title: "5", category: .stretch, priority: .general, notificationInterval: 5, createdAt: .now),
            .init(title: "6", category: .vitamins, priority: .important, notificationInterval: 6, createdAt: .now),
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            assertSnapshot(of: remindsController, as: .image)
        }
    }
    
    func testRemindDetail() throws {
        let remind = Remind(
            title: "Snapshot testing title",
            category: .breathing,
            priority: .general,
            notificationInterval: 2,
            createdAt: .now
        )
        let remindDetailView = RemindDetailView(remind: remind, usingAnimation: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            assertSnapshot(of: remindDetailView, as: .image)
        }
    }
}
