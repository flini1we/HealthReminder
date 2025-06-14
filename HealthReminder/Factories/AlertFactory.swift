import UIKit

final class AlertFactory {
    
    static func showSettingsAlert(
        in viewController: UIViewController?,
        title: String,
        message: String,
        onCancel: (() -> Void)? = nil
    ) {
        guard let viewController else { return }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(
            title: .settings,
            style: .default
        ) { _ in
            guard
                let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingsUrl)
            else { return }
            UIApplication.shared.open(settingsUrl)
        }
        
        let cancelAction = UIAlertAction(
            title: .cancel,
            style: .cancel,
            handler: { _ in onCancel?() }
        )
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true)
    }
}

private extension String {
    
    static let settings = "Настройки"
    static let cancel = "Отмена"
}
