import UIKit

final class RemindCell: UITableViewCell {
    
    static var identifier: String {
        "\(self)"
    }
    
    private lazy var bgView: UIView = {
        let view = UIView().autoLayout()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = .Padding.normal
        view.addShadow(
            opacity: .lowOpacity,
            offset: .init(width: 0, height: 5),
            radius: .Padding.small,
            shouldRasterize: true
        )
        return view
    }()
    
    private lazy var iconContainer: UIView = {
        let view = UIView().autoLayout()
        view.backgroundColor = .systemGray6
        view.addShadow()
        view.layer.cornerRadius = .Padding.semiSmall
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView().autoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel().autoLayout()
        label.font = .systemFont(ofSize: .Fonts.small, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().autoLayout()
        label.font = .systemFont(ofSize: .Fonts.default, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priorityBadge: UILabel = {
        let label = UILabel().autoLayout()
        label.font = .systemFont(ofSize: .Fonts.small, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = .badgeRadius
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var intervalLabel: UILabel = {
        let label = UILabel().autoLayout()
        label.font = .systemFont(ofSize: .Fonts.tiny)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel().autoLayout()
        label.font = .systemFont(ofSize: .Fonts.tiny)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel
        ]).autoLayout()
        stack.axis = .vertical
        stack.spacing = .Padding.tiny
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            iconContainer,
            textStackView,
            priorityBadge
        ]).autoLayout()
        stack.spacing = .Padding.semiSmall
        stack.alignment = .center
        return stack
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            intervalLabel,
            dateLabel
        ]).autoLayout()
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            topStackView,
            bottomStackView
        ]).autoLayout()
        stack.axis = .vertical
        stack.spacing = .Padding.semiSmall
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with remind: Remind) {
        
        iconImageView.image = UIImage(systemName: remind.category.systemIcon)
        categoryLabel.text = remind.category.displayName
        titleLabel.text = remind.title
        dateLabel.text = remind.createdAt
        
        priorityBadge.text = remind.priority.rawValue
        priorityBadge.backgroundColor = remind.priority.color.withAlphaComponent(0.1)
        priorityBadge.textColor = remind.priority.color
        
        let tail = (remind.notificationInterval == 1) ? "" : "s"
        let timeIntervalLabelString = "  Every \(remind.notificationInterval) hour" + tail
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: .bellImage)?.withTintColor(.systemGray)
        let attributedString = NSMutableAttributedString(attachment: attachment)
        attributedString.append(NSAttributedString(string: timeIntervalLabelString))
        intervalLabel.attributedText = attributedString
    }
}

private extension RemindCell {
    
    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubview(mainStackView)
        iconContainer.addSubview(iconImageView)
    }
    
    func setupConstraints() {
        bgView.pinEdges(inset: .Padding.small, for: [.top, .bottom])
        mainStackView.pinEdges(inset: .Padding.normal)
        
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: .iconContainerWidth),
            iconContainer.heightAnchor.constraint(equalToConstant: .iconContainerWidth),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: .iconContainerWidth * 0.75),
            iconImageView.heightAnchor.constraint(equalToConstant: .iconContainerWidth * 0.75),
            
            priorityBadge.heightAnchor.constraint(equalToConstant: .badgeRadius * 2),
            priorityBadge.widthAnchor.constraint(equalToConstant: .badgeWidth)
        ])
    }
}

private extension Float {
    
    static let lowOpacity: Float = 0.05
}

private extension CGFloat {
    
    static let badgeRadius: CGFloat = 12.5
    static let iconContainerWidth: CGFloat = 40
    static let badgeWidth: CGFloat = UIScreen.main.bounds.width / 4
    static let bellImageHeight: CGFloat = 10
}

private extension String {
    
    static let bellImage = "bell.and.waves.left.and.right.fill"
}
