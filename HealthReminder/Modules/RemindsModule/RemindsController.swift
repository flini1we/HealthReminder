import UIKit

protocol IRemindsView: AnyObject {
    
    func remindsDidLoad()
}

final class RemindsController: UIViewController {
    
    private var remindsView: UIView {
        view as! RemindsView
    }
    private var presenter: IRemindsPresenter
    
    init(presenter: IRemindsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
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
        presenter.viewDidLoad()
    }
}

extension RemindsController: IRemindsView {
    
    func remindsDidLoad() {
        print("reminds loaded reload view")
    }
}
