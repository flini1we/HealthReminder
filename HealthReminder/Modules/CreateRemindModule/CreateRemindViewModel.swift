import SwiftUI

protocol ICreateRemindViewModel: ObservableObject {
    
    var remindTitle: String { get set }
    var selectedType: RemindType { get set }
    var interval: Int { get set }
    var remindPriority: RemindsPriority { get set }
}

final class CreateRemindViewModel: ICreateRemindViewModel {
    
    @Published var remindTitle: String = ""
    @Published var selectedType: RemindType = .drinkWater
    @Published var interval: Int = 1
    @Published var remindPriority: RemindsPriority = .general
    
    var isTextFieldEmpty: Bool {
        remindTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var intervalText: String {
        return interval == 1 ? "Every hour" : "Every \(interval) hours"
    }
    
    func buildRemind() -> Remind {
        return RemindBuilder()
            .title(remindTitle)
            .category(selectedType)
            .notificationInterval(interval)
            .priority(remindPriority)
            .createdAt(.now)
            .build()
    }
}
