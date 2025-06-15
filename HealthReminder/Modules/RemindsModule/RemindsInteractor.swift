import UIKit
import Combine
import SwiftData

protocol IRemindsInteractor: AnyObject {
    
    var presenter: IRemindsPresenter? { get set }
    var reminds: [Remind] { get }
    var remindsPublisher: Published<[Remind]>.Publisher { get }
    var selectedRemindsCategory: RemindsPriority { get set }
    var selectedRemindsCategoryPublisher: Published<RemindsPriority>.Publisher { get }
    
    func loadReminds() async -> [Remind]
    func addRemind(_ remind: Remind) async
}

final class RemindsInteractor {
    
    private var dataManager: ISwiftDataManager
    
    weak var presenter: IRemindsPresenter?
    private var container: ModelContainer?
    
    @Published var selectedRemindsCategory: RemindsPriority = .all
    var selectedRemindsCategoryPublisher: Published<RemindsPriority>.Publisher {
        $selectedRemindsCategory
    }
    @Published var reminds: [Remind] = []
    var remindsPublisher: Published<[Remind]>.Publisher {
        $reminds
    }
    
    init(dataManager: ISwiftDataManager) {
        self.dataManager = dataManager
        Task {
            self.reminds = await dataManager.loadReminds().map { $0.convertToRemind() }
        }
    }
}

extension RemindsInteractor: IRemindsInteractor {
        
    func loadReminds() async -> [Remind] {
        if selectedRemindsCategory == .all {
            return reminds
        }
        
        let filteredReminds = reminds.filter {
            $0.priority == selectedRemindsCategory
        }
        return filteredReminds
    }
    
    func addRemind(_ remind: Remind) async {
        reminds.append(remind)
        dataManager.addRemind(remind)
    }
}
