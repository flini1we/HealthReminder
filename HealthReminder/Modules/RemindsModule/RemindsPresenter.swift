import UIKit

protocol IRemindsPresenter: AnyObject {
    
    var controller: IRemindsView? { get set }
    
    func viewDidLoad()
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
        print("controller loaded view start load data")
    }
}
