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
            opacity: 0.1,
            offset: .init(width: 3, height: 3),
            radius: 4,
            shouldRasterize: true
        )
        return view
    }()
    
    private lazy var remindImageView: UIImageView = {
        let imageView = UIImageView().autoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.image = UIImage(systemName: "bell.fill")
        return imageView
    }()
    
    private lazy var remindTitle: UILabel = {
        let label = UILabel().autoLayout()
        label.font = .systemFont(ofSize: .Fonts.default, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel().autoLayout()
        label.font = .systemFont(ofSize: .Fonts.small, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var remindDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            remindTitle,
            timeLabel
        ]).autoLayout()
        stack.axis = .vertical
        stack.spacing = .Padding.small
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            remindImageView,
            remindDataStackView
        ]).autoLayout()
        stack.spacing = .Padding.normal
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithRemind(_ remind: Remind) {
        remindTitle.text = remind.title
        timeLabel.text = DateFormatter.standard.formatRelative(.now)
    }
}

private extension RemindCell {
    
    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubview(dataStackView)
    }
    
    func setupConstraints() {
        bgView.pinEdges(inset: .Padding.small, for: [.top, .bottom])
        dataStackView.pinEdges(inset: .Padding.normal)
    }
}
