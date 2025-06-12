import UIKit

protocol IRemindsAssembly {
    
    func resolveRemindsModule() -> UIViewController
}

final class RemindsAssembly: IRemindsAssembly {
    
    private let container: IDIContainer
    
    init(container: IDIContainer) {
        self.container = container
        registerModules()
    }
    
    func resolveRemindsModule() -> UIViewController {
        guard
            let remindsRouter = container.resolve(type: IRemindsRouter.self),
            let remindsInteractor = container.resolve(type: IRemindsInteractor.self),
            let remindsPresenter = container.resolve(type: IRemindsPresenter.self),
            let remindsController = container.resolve(type: IRemindsView.self)
        else {
            fatalError(.registerModulesFirst)
        }
        remindsRouter.presenter = remindsPresenter
        remindsInteractor.presenter = remindsPresenter
        remindsPresenter.controller = remindsController
        guard
            let controller = remindsController as? UIViewController
        else {
            fatalError(.downcastExeption)
        }
        return controller
    }
}

private extension RemindsAssembly {
    
    func registerModules() {
        
        container.register(type: IRemindsRouter.self, service: RemindsRouter())
        container.register(type: IRemindsInteractor.self, service: RemindsInteractor())
        guard
            let router = container.resolve(type: IRemindsRouter.self),
            let interactor = container.resolve(type: IRemindsInteractor.self)
        else {
            fatalError(.shouldRegisterRouterInteractor)
        }
        container.register(type: IRemindsPresenter.self, service: RemindsPresenter(
            router: router,
            interactor: interactor)
        )
        guard
            let presenter = container.resolve(type: IRemindsPresenter.self)
        else {
            fatalError(.shouldRegisterPresenter)
        }
        container.register(type: IRemindsView.self, service: RemindsController(presenter: presenter))
    }
}

private extension String {
    
    static let downcastExeption = "Ошибка преобразования типа проверьте зарегистрированные модули"
    static let registerModulesFirst = "Модуль не был зарегистрирован в момент resolve"
    static let shouldRegisterRouterInteractor = "Моудули роутера и интерактора не были зарегистрированы в котейнере"
    static let shouldRegisterPresenter = "Модуль presenter не был зарегистрирован"
}
