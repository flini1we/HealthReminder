import UIKit

final class RemindsDelegate: NSObject, UITableViewDelegate {
    
    var onRemindDidTap: ((Int) -> Void)?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        UIView.animate(withDuration: 0.175) {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                cell?.transform = .identity
            } completion: { _ in
                self.onRemindDidTap?(indexPath.row)
            }
        }
    }
}
