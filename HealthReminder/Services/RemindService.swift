import UIKit
import Combine

protocol IRemindService {
    
    var controllerToPresentAlert: IRemindsView! { get set }
    var remindsPublisher: AnyPublisher<[Remind], Never> { get }
    var newRemindPublisher: AnyPublisher<Remind, Never> { get }
    
    func appendRemind(_ remind: Remind)
}

final class RemindService: IRemindService {
    var controllerToPresentAlert: IRemindsView!
    private var reminds: [Remind] = []
    private let remindsSubject = CurrentValueSubject<[Remind], Never>([])
    private let newRemindSubject = PassthroughSubject<Remind, Never>()
    
    var remindsPublisher: AnyPublisher<[Remind], Never> {
        remindsSubject.eraseToAnyPublisher()
    }
    
    var newRemindPublisher: AnyPublisher<Remind, Never> {
        newRemindSubject.eraseToAnyPublisher()
    }
    
    func appendRemind(_ remind: Remind) {
        do {
            let notificationCervice: IPushNotificationService = try ServiceLocator.shared.resolve()
            Task {
                let isNotificationGranted = await notificationCervice.isNotificationGranted()
                if isNotificationGranted {
                    
                } else {
                    guard let controller = controllerToPresentAlert as? UIViewController else { return }
                    AlertFactory.showSettingsAlert(
                        in: controller,
                        title: .notificationsDenied,
                        message: .acceptNotificationsInSettings
                    )
                }
            }
        } catch {
            fatalError("Register push notification cervice first")
        }
        reminds.append(remind)
        remindsSubject.send(reminds)
        newRemindSubject.send(remind)
    }
}

private extension String {
    
    static let notificationsDenied = "Уведомления отключены"
    static let acceptNotificationsInSettings = "Разрешите уведомления в настройках, чтобы не пропускать важные события"
}
