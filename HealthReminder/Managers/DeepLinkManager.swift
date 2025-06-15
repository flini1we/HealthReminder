import UIKit
import SwiftUI

final class DeepLinkManager {
    
    static let shared = DeepLinkManager()
    
    private init() { }
    
    func handleDeepLink(for url: URL, navigationController: UINavigationController) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let host = components.host
        else { return }
        
        switch host {
        case .remindHost:
            guard let queryRemind = parseRemind(from: components) else { return }
            navigationController.pushViewController(
                UIHostingController(
                    rootView: RemindDetailView(remind: queryRemind, usingAnimation: true)),
                animated: true
            )
        default:
            return
        }
    }
}

private extension DeepLinkManager {
    
    func parseRemind(from components: URLComponents) -> Remind? {
        guard
            let queryItems = components.queryItems,
            let title = queryItems.first(where: { $0.name == "title" })?.value,
            let categoryValue = queryItems.first(where: { $0.name == "category" })?.value,
            let category = RemindType(rawValue: categoryValue),
            let priorityValue = queryItems.first(where: { $0.name == "priority" })?.value,
            let priority = RemindsPriority(rawValue: priorityValue),
            let intervalString = queryItems.first(where: { $0.name == "notificationInterval" })?.value,
            let interval = Int(intervalString),
            let createdAt = queryItems.first(where: { $0.name == "createdAt" })?.value
        else {
            return nil
        }
        return Remind(
            title: title,
            category: category,
            priority: priority,
            notificationInterval: interval,
            createdAt: createdAt
        )
    }
}
