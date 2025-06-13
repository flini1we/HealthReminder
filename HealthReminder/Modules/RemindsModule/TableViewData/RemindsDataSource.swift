import UIKit

enum RemindsSections {
    
    case main
}

final class RemindsDataSource: NSObject {
    
    private var dataSource: UITableViewDiffableDataSource<RemindsSections, Remind>?
    private weak var tableView: UITableView?
    
    override init() {
        dataSource?.defaultRowAnimation = .fade
        super.init()
    }
    
    func setupWithTable(tableView: UITableView, reminds: [Remind]) {
        self.tableView = tableView
        dataSource = .init(
            tableView: tableView,
            cellProvider: { tableView, indexPath, remind in
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: RemindCell.identifier, for: indexPath) as? RemindCell
                else { return UITableViewCell() }
                cell.setupWithRemind(remind)
                return cell
            }
        )
        applyFreshSnapshot(with: reminds)
    }
    
    func updateData(_ reminds: [Remind]) {
        applyFreshSnapshot(with: reminds)
    }
}

private extension RemindsDataSource {
    
    func applyFreshSnapshot(with reminds: [Remind]) {
        var snapshot = NSDiffableDataSourceSnapshot<RemindsSections, Remind>()
        snapshot.appendSections([.main])
        snapshot.appendItems(reminds)
        dataSource?.apply(snapshot)
    }
}
