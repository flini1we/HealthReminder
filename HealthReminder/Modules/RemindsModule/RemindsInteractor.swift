import UIKit

protocol IRemindsInteractor: AnyObject {
    
    var presenter: IRemindsPresenter? { get set }
    
    func loadReminds() async -> [Remind]
}

final class RemindsInteractor {
    
    weak var presenter: IRemindsPresenter?
}

extension RemindsInteractor: IRemindsInteractor {
    
    func loadReminds() async -> [Remind] {
        
        try? await Task.sleep(nanoseconds: 2000)
        return [
            .init(title: "Completi iOS"),
            .init(title: "Finish working"),
            .init(title: "etc")
        ]
    }
}
