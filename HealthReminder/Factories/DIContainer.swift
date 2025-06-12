import UIKit

protocol IDIContainer {
    
    func register<Service>(type: Service.Type, service: Any)
    func resolve<Service>(type: Service.Type) -> Service?
}

final class DIContainer: IDIContainer {
    
    private var services: [String: Any] = [:]
    
    func register<Service>(type: Service.Type, service: Any) {
        services["\(type)"] = service
    }

    func resolve<Service>(type: Service.Type) -> Service? {
      return services["\(type)"] as? Service
    }
}
