import SwiftUI

final class CreateRemindViewModel: ObservableObject {
    
    @Published var remindTitle: String = ""
    @Published var selectedType: RemindType = .drinkWater
    @Published var interval: Int = 1 
    
    var isTextFieldEmpty: Bool {
        remindTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var intervalText: String {
        return interval == 1 ? "Every hour" : "Every \(interval) hours"
    }
}
