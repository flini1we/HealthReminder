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
        remindsInteractor.presenter = remindsPresenter
        remindsRouter.controller = remindsController
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
        container.register(type: ExpandedStateManager.self, service: ExpandedStateManager())
        container.register(type: SheetOpenerManager.self, service: SheetOpenerManager())
        container.register(type: ISwiftDataManager.self, service: SwiftDataManager())
        guard
            let expandedStateManager = container.resolve(type: ExpandedStateManager.self),
            let sheetOpenerManager = container.resolve(type: SheetOpenerManager.self)
        else {
            fatalError(.shouldRegisterManagersFirst)
        }
        container.register(type: IRemindsRouter.self, service: RemindsRouter(
            expandedStateManager: expandedStateManager, sheetOpenerManager: sheetOpenerManager)
        )
        guard
            let dataManager = container.resolve(type: ISwiftDataManager.self)
        else {
            fatalError(.shouldRegisterDataManagerFirst)
        }
        container.register(type: IRemindsInteractor.self, service: RemindsInteractor(dataManager: dataManager))
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
    
    static let shouldRegisterManagersFirst = "Ошибка регистрации менеджеров"
    static let shouldRegisterDataManagerFirst = "Ошибка регистрации менеджера даных"
    static let downcastExeption = "Ошибка преобразования типа проверьте зарегистрированные модули"
    static let registerModulesFirst = "Модуль не был зарегистрирован в момент resolve"
    static let shouldRegisterRouterInteractor = "Моудули роутера и интерактора не были зарегистрированы в котейнере"
    static let shouldRegisterPresenter = "Модуль presenter не был зарегистрирован"
}
