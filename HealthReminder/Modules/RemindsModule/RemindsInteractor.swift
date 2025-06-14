import UIKit
import Combine

protocol IRemindsInteractor: AnyObject {
    
    var presenter: IRemindsPresenter? { get set }
    var reminds: [Remind] { get }
    var selectedRemindsCategory: RemindsPriority { get set }
    var selectedRemindsCategoryPublisher: Published<RemindsPriority>.Publisher { get }
    
    func loadReminds() async -> [Remind]
    func addRemind(_ remind: Remind) async
}

final class RemindsInteractor {
    
    weak var presenter: IRemindsPresenter?
    @Published var selectedRemindsCategory: RemindsPriority = .all
    var selectedRemindsCategoryPublisher: Published<RemindsPriority>.Publisher {
        $selectedRemindsCategory
    }
    private(set) var reminds: [Remind]
    
    init() {
        reminds = [
            .init(title: "Drink water", category: .drinkWater, priority: .daily, notificationInterval: 4, createdAt: ""),
            .init(title: "Gym", category: .workout, priority: .general, notificationInterval: 12, createdAt: ""),
            .init(title: "Stretching", category: .stretch, priority: .important, notificationInterval: 20, createdAt: "")
        ]
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
    }
}
