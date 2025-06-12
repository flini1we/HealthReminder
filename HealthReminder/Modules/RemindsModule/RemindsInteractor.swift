import UIKit

protocol IRemindsInteractor: AnyObject {
    
    var presenter: IRemindsPresenter? { get set }
}

final class RemindsInteractor {
    
    weak var presenter: IRemindsPresenter?
}

extension RemindsInteractor: IRemindsInteractor {
    
}
