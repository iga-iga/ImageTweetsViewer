import Combine
import UIKit

final class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var historyLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    
    let onDeleteButtonTapped = PassthroughSubject<SearchDetailViewModel.History, Never>()
    private var bindings = Set<AnyCancellable>()
    private var history: SearchDetailViewModel.History?
    
    func set(_ viewData: SearchDetailViewModel.History) {
        self.history = viewData
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
        guard let history = self.history else { return }
        self.onDeleteButtonTapped.send(history)
    }
}
