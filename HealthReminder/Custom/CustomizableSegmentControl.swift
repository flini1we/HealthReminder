import UIKit

final class CustomizableSegmentControl: UISegmentedControl {
    
    lazy var radius = bounds.height / 2
    
    private var lastSelectedIndex: Int = -1
    private let segmentIcons = RemindsPriority.allCases.map { $0.image }
    private let segmentTitles = RemindsPriority.allCases.map { $0.rawValue }
    
    private var segmentInset: CGFloat = .overridedSegmentInset {
        didSet {
            if segmentInset == 0 { segmentInset = .overridedSegmentInset }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemGray6
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        let selectedImageViewIndex = numberOfSegments
        if selectedSegmentIndex != -1 {
            if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
                selectedImageView.backgroundColor = .systemBackground
                selectedImageView.image = nil
                
                selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
                selectedImageView.layer.cornerRadius = radius
                selectedImageView.clipsToBounds = true
                
                selectedImageView.layer.removeAnimation(forKey: .boundsAnimationKey)
            }
        }
    }
}

private extension String {
    
    static let boundsAnimationKey = "SelectionBounds"
}

private extension CGFloat {
    
    static let overridedSegmentInset: CGFloat = 0.1
}
