import Combine
import UIKit

final class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var historyLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    
    let onDeleteButtonTapped = PassthroughSubject<Void, Never>()
    private var bindings = Set<AnyCancellable>()
    
    func set(_ viewData: SearchDetailViewModel.History) {
        var additionalText = ""
        viewData.querys.forEach { query in
            if query.isValidated {
                additionalText += " \(query.key):\(query.value)"
            }
        }
        self.historyLabel.text = viewData.searchText + additionalText
        
        self.deleteButton.setTitle("", for: .normal)
        self.deleteButton.addTarget(
            self,
            action: #selector(self.onDeleteButtonTappedEvent),
            for: .touchUpInside
        )
    }
    
    @objc private func onDeleteButtonTappedEvent(_ sender: UIButton) {
        self.onDeleteButtonTapped.send()
    }
}
