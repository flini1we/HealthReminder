import UIKit
import UserNotifications

protocol IPushNotificationService {

    func registerForNotification() async throws -> Bool
    func isNotificationGranted() async -> Bool
    func presetnNotificationRequest(_ request: UNNotificationRequest)
}

final class PushNotificationService: NSObject, IPushNotificationService {

    private let notificationCenter = UNUserNotificationCenter.current()
    
    private lazy var jsonDecoder: JSONDecoder = { JSONDecoder() }()

    override init() {
        super.init()
        notificationCenter.delegate = self
    }

    func registerForNotification() async throws -> Bool {
        try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
    }
    
    func isNotificationGranted() async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
    }
    
    func presetnNotificationRequest(_ request: UNNotificationRequest) {
        notificationCenter.add(request)
    }
}

extension PushNotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        guard
            let remindDict = userInfo["remind"] as? [String: Any]
        else {
            print("Error to acces notification data")
            return
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: remindDict)
            let remind = try jsonDecoder.decode(Remind.self, from: jsonData)
            
            guard
                let remindDetailDeeplink = DeeplinkRemindDetailBuilder()
                                            .buildRemindDetailDeeplink(for: remind)
            else { return }
            DispatchQueue.main.async {
                UIApplication.shared.open(remindDetailDeeplink)
            }
        } catch {
            print("Decoding Remind error: \(error)")
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound, .badge]
    }
}
