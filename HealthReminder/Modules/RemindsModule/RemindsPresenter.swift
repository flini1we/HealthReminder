import UIKit

protocol IRemindsPresenter: AnyObject {
    
    var controller: IRemindsView? { get set }
    
    func viewDidLoad()
    func createButtonDidTap()
}

final class RemindsPresenter {
    
    weak var controller: IRemindsView?
    private var remindsRouter: IRemindsRouter
    private var remindsInteractor: IRemindsInteractor
    
    init(router: IRemindsRouter, interactor: IRemindsInteractor) {
        self.remindsRouter = router
        self.remindsInteractor = interactor
    }
}

extension RemindsPresenter: IRemindsPresenter {
    
    func viewDidLoad() {
        Task {
            let reminds = await remindsInteractor.loadReminds()
            
            await MainActor.run {
                controller?.remindsDidLoad(reminds)
            }
        }
    }
    
    func createButtonDidTap() {
        remindsRouter.showCreateScreen()
    }
}
