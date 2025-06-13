import UIKit

extension UIButton.Configuration {
    
    static func customButtonConfiguration(
        title: String,
        backgroundColor: UIColor,
        textColor: UIColor = .label,
        font: UIFont
    ) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = textColor
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            return outgoing
        }
        configuration.cornerStyle = .capsule
        return configuration
    }
}
