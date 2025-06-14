import UIKit

enum RemindsSections {
    
    case main
}

final class RemindsDataSource: NSObject {
    
    private var dataSource: UITableViewDiffableDataSource<RemindsSections, Remind>?
    private weak var tableView: UITableView?
    
    func setupWithTable(tableView: UITableView, reminds: [Remind]) {
        self.tableView = tableView
        dataSource = .init(
            tableView: tableView,
            cellProvider: { tableView, indexPath, remind in
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: RemindCell.identifier, for: indexPath) as? RemindCell
                else { return UITableViewCell() }
                cell.configure(with: remind)
                return cell
            }
        )
        dataSource?.defaultRowAnimation = .fade
        PerformOnMain {
            self.applyFreshSnapshot(with: reminds)
        }
    }
    
    func updateData(_ reminds: [Remind]) {
        PerformOnMain {
            self.applyFreshSnapshot(with: reminds)
        }
    }
    
    func addRemind(_ remind: Remind) {
        PerformOnMain {
            self.addElement(remind)
        }
    }
}

private extension RemindsDataSource {
    
    func applyFreshSnapshot(with reminds: [Remind]) {
        var snapshot = NSDiffableDataSourceSnapshot<RemindsSections, Remind>()
        snapshot.appendSections([.main])
        snapshot.appendItems(reminds)
        dataSource?.apply(snapshot)
    }
    
    func addElement(_ remin: Remind) {
        guard var snapshot = dataSource?.snapshot() else { return }
        let reminds = snapshot.itemIdentifiers(inSection: .main)
        if !reminds.isEmpty {
            if reminds[0].priority != remin.priority {
                return
            }
        }
        snapshot.appendItems([remin], toSection: .main)
        dataSource?.apply(snapshot)
    }
    
    func PerformOnMain(completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            completion()
        }
    }
}
