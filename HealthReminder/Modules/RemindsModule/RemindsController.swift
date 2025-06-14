import UIKit

protocol IRemindsView: AnyObject {
    
    func remindsDidLoad(_ reminds: [Remind])
    func insertNewRemind(_ remind: Remind)
}

final class RemindsController: UIViewController {
    
    private var remindsView: RemindsView {
        view as! RemindsView
    }
    private var presenter: IRemindsPresenter
    private var remindsDataSource: RemindsDataSource?
    
    init(presenter: IRemindsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.controller = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = RemindsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
}

extension RemindsController: IRemindsView {
    
    func remindsDidLoad(_ reminds: [Remind]) {
        remindsDataSource?.updateData(reminds)
    }
    
    func insertNewRemind(_ remind: Remind) {
        remindsDataSource?.addRemind(remind)
        if remindsView.remindsCategorySegmentControl.selectedSegmentIndex == 0 {
            presenter.loadData()
        }
    }
}

private extension RemindsController {
    
    func setup() {
        setupDataSource()
        setupBindings()
    }
    
    func setupDataSource() {
        remindsDataSource = RemindsDataSource()
        remindsDataSource?.setupWithTable(tableView: remindsView.remindsTableView, reminds: [])
    }
    
    func setupBindings() {
        remindsView.onAddRemindAction = { [weak self] in
            self?.presenter.createButtonDidTap()
        }
        
        remindsView.onPriorityDidChange = { [weak self] priority in
            self?.presenter.onUpdateRemindPriotiryValue(priority)
        }
    }
}
