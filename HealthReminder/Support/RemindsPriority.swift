import UIKit

enum RemindsPriority: String, CaseIterable, Codable {
    
    case all = "All"
    case important = "Important"
    case general = "General"
    case daily = "Daily"
    
    var embend: String {
        self.rawValue.lowercased()
    }
    
    var image: UIImage {
        var image: UIImage
        switch self {
        case .important:
            image = UIImage(systemName: "heart.fill")!
        case .general:
            image = UIImage(systemName: "staroflife.fill")!
        case .daily, .all:
            image = UIImage(systemName: "clock.fill")!
        }
        image.withTintColor(.baseBG, renderingMode: .alwaysOriginal)
        return image
    }
    
    var color: UIColor {
        switch self {
        case .all:
            return .systemGray6
        case .important:
            return .systemRed
        case .general:
            return .systemBlue
        case .daily:
            return .systemGreen
        }
    }
}
