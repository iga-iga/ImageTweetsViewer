import UIKit

protocol IdentifiableView {}

extension IdentifiableView {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: IdentifiableView {}

extension UICollectionViewCell: IdentifiableView {}
