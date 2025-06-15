import SwiftData

protocol ISwiftDataManager {
    
    func loadReminds() async -> [RemindModel]
    func addRemind(_ remind: Remind)
}

final class SwiftDataManager: ISwiftDataManager {
    
    private var container: ModelContainer?
    private let remindDescriptor = FetchDescriptor<RemindModel>()
    
    init() {
        configure()
    }
    
    func loadReminds() async -> [RemindModel] {
        await loadRemindModels()
    }
    
    func addRemind(_ remind: Remind) {
        Task {
            await saveRemindToStorage(remind)
        }
    }
}

private extension SwiftDataManager {
    
    func configure() {
        do {
            container = try ModelContainer(for: RemindModel.self)
        } catch {
            fatalError("")
        }
    }
    
    @MainActor
    func loadRemindModels() -> [RemindModel] {
        do {
            return try container?.mainContext.fetch(remindDescriptor) ?? []
        } catch {
            print("Error to load data from storage")
            return []
        }
    }
    
    @MainActor
    func saveRemindToStorage(_ remind: Remind) {
        container?.mainContext.insert(RemindModel(from: remind))
        do {
            try container?.mainContext.save()
        } catch {
            print("Error saving remind")
        }
    }
}
