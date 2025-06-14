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
    
    init() {
        do {
            container = try ModelContainer(for: RemindModel.self)
            Task {
                self.reminds = await self.loadData()
            }
        } catch {
            print("Error to setup container: \(error.localizedDescription)")
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
    
    @MainActor
    func addRemind(_ remind: Remind) async {
        reminds.append(remind)
        container?.mainContext.insert(RemindModel(from: remind))
        do {
            try container?.mainContext.save()
        } catch {
            print("Error to save data: \(error.localizedDescription)")
        }
    }
}

private extension RemindsInteractor {
    
    @MainActor
    func loadData() -> [Remind] {
        let descriptor = FetchDescriptor<RemindModel>()
    
        let reminds = (try? self.container?.mainContext.fetch(descriptor)) ?? []
        return reminds.map { $0.convertToRemind() }
    }
}
