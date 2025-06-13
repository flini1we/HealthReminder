import UIKit

final class RemindsView: UIView {
    var onAddRemindAction: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().autoLayout()
        label.text = .screenTitle
        label.font = .systemFont(ofSize: .Fonts.title, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var addRemindButton: UIButton = {
        let button = UIButton(
            configuration: .customButtonConfiguration(
                title: .addRemindButtonTitle,
                backgroundColor: .baseBG,
                font: .systemFont(ofSize: .Fonts.normal, weight: .semibold)
            )
        ).autoLayout()
        button.addPressAnimation { [weak self] in
            self?.onAddRemindAction?()
        }
        button.addGlow(color: .baseBG)
        return button
    }()
    
    private lazy var editRemindButton: UIButton = {
        let button = UIButton(
            configuration: .customButtonConfiguration(
                title: .editRemindsButtonTitle,
                backgroundColor: .systemGray6,
                font: .systemFont(ofSize: .Fonts.normal, weight: .semibold)
            )
        ).autoLayout()
        button.clipsToBounds = true
        button.layer.cornerRadius = .Padding.normal
        button.addPressAnimation {
            
        }
        return button
    }()
    
    private(set) lazy var remindsCategorySegmentControl: CustomizableSegmentControl = {
        let segment = CustomizableSegmentControl(
            items: RemindsPriority.allCases.map {
                $0.rawValue
            }
        ).autoLayout()
        segment.setDividerImage(
            UIImage(),
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )

        segment.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: .Fonts.normal, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel
        ], for: .normal)
        
        segment.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: .Fonts.normal, weight: .semibold),
            .foregroundColor: UIColor.label
        ], for: .selected)
        
        return segment
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            editRemindButton,
            addRemindButton
        ]).autoLayout()
        stack.spacing = .Padding.small
        stack.alignment = .center
        return stack
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel().autoLayout()
        label.text = .screenSubTitle
        label.font = .systemFont(ofSize: .Fonts.default, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleButtonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            buttonsStackView
        ]).autoLayout()
        stack.spacing = .Padding.normal
        stack.alignment = .center
        return stack
    }()
    
    private lazy var screenTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleButtonStackView,
            subtitleLabel
        ]).autoLayout()
        stack.axis = .vertical
        stack.spacing = .Padding.small
        return stack
    }()
    
    private(set) lazy var remindsTableView: UITableView = {
        let table = UITableView().autoLayout()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        table.register(RemindCell.self, forCellReuseIdentifier: RemindCell.identifier)
        return table
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            screenTitleStack,
            remindsTableView
        ]).autoLayout()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = .Padding.normal
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func corneringSegment() {
        remindsCategorySegmentControl.layer.cornerRadius = remindsCategorySegmentControl.frame.height / 2
    }
}

private extension RemindsView {
    
    func setup() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(dataStackView)
        addSubview(remindsCategorySegmentControl)
    }

    func setupConstraints() {
        dataStackView.pinEdges(inset: .Padding.normal, for: [.leading, .trailing, .bottom])
        
        NSLayoutConstraint.activate([
            remindsCategorySegmentControl.widthAnchor.constraint(equalToConstant: .segmentWidth),
            remindsCategorySegmentControl.heightAnchor.constraint(equalToConstant: .UIElements.segmentHeight),
            remindsCategorySegmentControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            remindsCategorySegmentControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

private extension String {
    
    static let screenTitle = "Reminders"
    static let screenSubTitle = "Stay on track with your health goals"
    static let addRemindButtonTitle = "Add"
    static let editRemindsButtonTitle = "Edit"
}

private extension CGFloat {
    
    static let segmentWidth: CGFloat = UIScreen.main.bounds.width * 0.85
}
