import Foundation

enum RemindType: String, CaseIterable, Identifiable, Codable {
    
    case drinkWater
    case stretch
    case vitamins
    case sleep
    case workout
    case meal
    case breathing
    
    var id: String {
        self.rawValue
    }
    
    var systemIcon: String {
        switch self {
        case .drinkWater:
            return "drop.fill"
        case .stretch:
            return "figure.walk"
        case .vitamins:
            return "pills.fill"
        case .sleep:
            return "bed.double.fill"
        case .workout:
            return "figure.run"
        case .meal:
            return "fork.knife"
        case .breathing:
            return "lungs.fill"
        }
    }
    
    var displayName: String {
        switch self {
        case .drinkWater:
            return "Water"
        case .stretch:
            return "Stretch"
        case .vitamins:
            return "Vitamins"
        case .sleep:
            return "Sleep"
        case .workout:
            return "Workout"
        case .meal:
            return "Meal"
        case .breathing:
            return "Breathing"
        }
    }
    
    static func fromRawValue(_ value: String) -> RemindType? {
        return RemindType.allCases.first { $0.rawValue == value }
    }
}
