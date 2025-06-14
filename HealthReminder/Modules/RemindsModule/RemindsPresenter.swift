import UIKit
import Combine

protocol IRemindsPresenter: AnyObject {
    
    var controller: IRemindsView? { get set }
    var remindService: IRemindService { get }
    
    func viewDidLoad()
    func createButtonDidTap()
    func handleNewRemind(_ remind: Remind)
    func onUpdateRemindPriotiryValue(_ priotiry: RemindsPriority)
    func loadData()
    func onRemindDidTap(at index: Int)
}

final class RemindsPresenter {
    
    weak var controller: IRemindsView? {
        didSet { onControllerDidSet?() }
    }
    var remindService: IRemindService
    private var remindsRouter: IRemindsRouter
    private var remindsInteractor: IRemindsInteractor
    private var canvellables: Set<AnyCancellable> = []
    var onControllerDidSet: (() -> Void)?
    
    init(router: IRemindsRouter, interactor: IRemindsInteractor) {
        self.remindsRouter = router
        self.remindsInteractor = interactor
        try! remindService = ServiceLocator.shared.resolve()
        remindService.controllerToPresentAlert = controller
        onControllerDidSet = { [weak self] in
            guard let self else { return }
            remindService.controllerToPresentAlert = controller
        }
        setupBindings()
    }
}

extension RemindsPresenter: IRemindsPresenter {
    
    func viewDidLoad() {
        requestForNotification()
        loadData()
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
    
    func loadData() {
        Task {
            let reminds = await remindsInteractor.loadReminds()
            controller?.remindsDidLoad(reminds)
        }
    }
    
    func onRemindDidTap(at index: Int) {
        let remind = remindsInteractor.reminds[index]
        guard
            let remindDetailDeeplink = remindsRouter.createDetailDeepLinkURL(for: remind)
        else { return }
        UIApplication.shared.open(remindDetailDeeplink)
    }
}

private extension RemindsPresenter {
    
    func requestForNotification() {
        do {
            let notificationCervice: IPushNotificationService = try ServiceLocator.shared.resolve()
            Task {
                try? await notificationCervice.registerForNotification()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
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
                self?.loadData()
            }
            .store(in: &canvellables)
        
        remindsInteractor
            .remindsPublisher
            .sink { [weak self] reminds in
                self?.loadData()
            }
            .store(in: &canvellables)
    }
}
