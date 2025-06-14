import UIKit
import SwiftUI
import Combine

protocol IRemindsRouter: AnyObject {
    
    var controller: IRemindsView? { get set }
    
    func showCreateScreen(remindService: IRemindService)
    func createDetailDeepLinkURL(for remind: Remind) -> URL?
}

final class RemindsRouter: NSObject {
    
    private let expandedStateManager: ExpandedStateManager
    private let sheetOpenerManager: SheetOpenerManager
    weak var controller: IRemindsView?
    private var cancellables: Set<AnyCancellable> = []
    private var couldBeExpanded: Bool = false
    
    init(expandedStateManager: ExpandedStateManager, sheetOpenerManager: SheetOpenerManager) {
        self.expandedStateManager = expandedStateManager
        self.sheetOpenerManager = sheetOpenerManager
        super.init()
        
        sheetOpenerManager.$couldOpen.sink { [weak self] couldOpenSheet in
            guard let self else { return }
            couldBeExpanded = couldOpenSheet
        }
        .store(in: &cancellables)
    }
}

extension RemindsRouter: IRemindsRouter {
    
    func showCreateScreen(remindService: IRemindService) {
        let createRemindController = UIHostingController(
            rootView: CreateRemindView(
                expandedStateManager: expandedStateManager,
                sheetOpenerManager: sheetOpenerManager,
                remindService: remindService
            )
        )
        createRemindController.view.backgroundColor = .clear
        guard let presentingController = controller as? UIViewController else { return }
        
        let maxDetent = UISheetPresentationController.Detent.custom(identifier: .max) { context in
            context.maximumDetentValue * 0.5
        }
        let minDetent = UISheetPresentationController.Detent.custom(identifier: .min) { context in
            context.maximumDetentValue * 0.2
        }
        
        if let sheet = createRemindController.sheetPresentationController {
            sheet.detents = [minDetent, maxDetent]
            sheet.delegate = self
        }
        
        presentingController.present(createRemindController, animated: true)
    }
    
    func createDetailDeepLinkURL(for remind: Remind) -> URL? {
        DeeplinkRemindDetailBuilder().buildRemindDetailDeeplink(for: remind)
    }
}

extension RemindsRouter: UISheetPresentationControllerDelegate {
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(
        _ sheetPresentationController: UISheetPresentationController
    ) {
        if !couldBeExpanded {
            sheetPresentationController.selectedDetentIdentifier = .min
            expandedStateManager.isExpanded = false
        }
        expandedStateManager.isExpanded = sheetPresentationController.selectedDetentIdentifier == .max
    }
}
