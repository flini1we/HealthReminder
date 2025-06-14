import UIKit
import Combine

protocol IRemindService {
    
    var remindsPublisher: AnyPublisher<[Remind], Never> { get }
    var newRemindPublisher: AnyPublisher<Remind, Never> { get }
    
    func appendRemind(_ remind: Remind)
}

final class RemindService: IRemindService {
    private var reminds: [Remind] = []
    private let remindsSubject = CurrentValueSubject<[Remind], Never>([])
    private let newRemindSubject = PassthroughSubject<Remind, Never>()
    
    var remindsPublisher: AnyPublisher<[Remind], Never> {
        remindsSubject.eraseToAnyPublisher()
    }
    
    var newRemindPublisher: AnyPublisher<Remind, Never> {
        newRemindSubject.eraseToAnyPublisher()
    }
    
    func appendRemind(_ remind: Remind) {
        reminds.append(remind)
        remindsSubject.send(reminds)
        newRemindSubject.send(remind)
    }
}
