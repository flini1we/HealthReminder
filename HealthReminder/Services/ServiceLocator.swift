import UIKit

// TODO: queue
final class ServiceLocator {
    
    static let shared = ServiceLocator()
    
    private var services: [String: Any] = [:]
    
    private init() {
        registerServices()
    }
    
    enum ServiceLocatorError: Error {
        case duplicateService(String)
        case inexistentService(String)
        case typeMismatch(String)
        
        var localizedDescription: String {
            switch self {
            case .duplicateService(let key):
                return "Service '\(key)' already registered"
            case .inexistentService(let key):
                return "Service '\(key)' not found"
            case .typeMismatch(let key):
                return "Type mismatch for service '\(key)'"
            }
        }
    }
    
    func register<T>(_ service: T) throws {
        let key = "\(T.self)"
        
        if services[key] != nil {
            throw ServiceLocatorError.duplicateService(key)
        }
        services[key] = service
    }
    
    func resolve<T>() throws -> T {
        let key = String(describing: T.self)
        
        guard let service = services[key] else {
            throw ServiceLocatorError.inexistentService(key)
        }
        
        guard let typedService = service as? T else {
            throw ServiceLocatorError.typeMismatch(key)
        }
        
        return typedService
    }
    
    func remove<T>(_ type: T.Type) throws {
        let key = String(describing: T.self)
        
        guard services[key] != nil else {
            throw ServiceLocatorError.inexistentService(key)
        }
        services.removeValue(forKey: key)
    }
}

private extension ServiceLocator {
    
    func registerServices() {
        do {
            try register(RemindService() as IRemindService)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
