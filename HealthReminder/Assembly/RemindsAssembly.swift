import UIKit

final class RemindsAssembly {
    
    static func resolveRemindsModule() -> UIViewController {
        
        let remindsRouter = RemindsRouter()
        let remindsInteractor = RemindsInteractor()
        let remindsPresenter = RemindsPresenter(router: remindsRouter, interactor: remindsInteractor)
        remindsRouter.presenter = remindsPresenter
        remindsInteractor.presenter = remindsPresenter
        let remindsController = RemindsController(presenter: remindsPresenter)
        remindsPresenter.controller = remindsController
        return remindsController
    }
}
