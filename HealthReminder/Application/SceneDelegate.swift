import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var remindsAssembly: RemindsAssembly!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let diContainer = DIContainer()
        remindsAssembly = RemindsAssembly(container: diContainer)
        let remindsNavigationController = UINavigationController(
            rootViewController: remindsAssembly.resolveRemindsModule()
        )
        window?.rootViewController = remindsNavigationController
        window?.makeKeyAndVisible()
        
        if CommandLine.arguments.contains("-deeplink"),
           let index = CommandLine.arguments.firstIndex(of: "-deeplink"),
           CommandLine.arguments.count > index + 1 {
            
            let deeplinkString = CommandLine.arguments[index + 1]
            if let url = URL(string: deeplinkString) {
                DeepLinkManager.shared.handleDeepLink(for: url, navigationController: remindsNavigationController)
            }
        }
        
        if CommandLine.arguments.contains("-fakePushNotification"),
           let index = CommandLine.arguments.firstIndex(of: "-fakePushNotification"),
           CommandLine.arguments.count > index + 1 {
            
            let pushPayload = CommandLine.arguments[index + 1]
            if let data = pushPayload.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let deeplinkString = json["deeplink"] as? String,
               let deeplinkURL = URL(string: deeplinkString) {
                
                DeepLinkManager.shared.handleDeepLink(for: deeplinkURL, navigationController: remindsNavigationController)
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard
            let deeplink = URLContexts.first?.url,
            let navigationController = window?.rootViewController as? UINavigationController
        else { return }
        
        DeepLinkManager.shared.handleDeepLink(
            for: deeplink,
            navigationController: navigationController
        )
    }
}

