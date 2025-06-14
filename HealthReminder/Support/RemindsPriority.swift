import UIKit

enum RemindsPriority: String, CaseIterable {
    
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
}
