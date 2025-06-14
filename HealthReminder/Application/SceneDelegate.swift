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

