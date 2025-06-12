import UIKit

protocol IRemindsRouter: AnyObject {
    
    var presenter: IRemindsPresenter? { get set }
}

final class RemindsRouter {
    
    weak var presenter: IRemindsPresenter?
    
}

extension RemindsRouter: IRemindsRouter {
    
}
