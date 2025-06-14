import UIKit
import Combine

protocol IRemindsPresenter: AnyObject {
    
    var controller: IRemindsView? { get set }
    var remindService: IRemindService { get }
    
    func viewDidLoad()
    func createButtonDidTap()
    func handleNewRemind(_ remind: Remind)
    func onUpdateRemindPriotiryValue(_ priotiry: RemindsPriority)
}

final class RemindsPresenter {
    
    weak var controller: IRemindsView?
    var remindService: IRemindService
    private var remindsRouter: IRemindsRouter
    private var remindsInteractor: IRemindsInteractor
    private var canvellables: Set<AnyCancellable> = []
    
    init(router: IRemindsRouter, interactor: IRemindsInteractor) {
        self.remindsRouter = router
        self.remindsInteractor = interactor
        try! remindService = ServiceLocator.shared.resolve()
        setupBindings()
    }
}

extension RemindsPresenter: IRemindsPresenter {
    
    func viewDidLoad() {
        Task {
            var reminds = await remindsInteractor.loadReminds()
            
            await MainActor.run {
                controller?.remindsDidLoad(reminds)
            }
        }
    }
    
    func createButtonDidTap() {
        remindsRouter.showCreateScreen(remindService: remindService)
    }
    
    func handleNewRemind(_ remind: Remind) {
        Task {
            await remindsInteractor.addRemind(remind)
            await MainActor.run {
                controller?.insertNewRemind(remind)
            }
        }
    }
    
    func onUpdateRemindPriotiryValue(_ priotiry: RemindsPriority) {
        remindsInteractor.selectedRemindsCategory = priotiry
    }
}

private extension RemindsPresenter {
    
    func setupBindings() {
        remindService
            .newRemindPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] remind in
                self?.handleNewRemind(remind)
            }
            .store(in: &canvellables)
        
        remindsInteractor
            .selectedRemindsCategoryPublisher
            .dropFirst()
            .sink { [weak self] priority in
                self?.viewDidLoad()
            }
            .store(in: &canvellables)
    }
}
