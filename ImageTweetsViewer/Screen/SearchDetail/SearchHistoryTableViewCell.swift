import Combine
import UIKit

final class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var historyLabel: UILabel!
    @IBOutlet private weak var deleteButton: SubscribableButton!
    
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
        self.deleteButton.onTapPublisher()
            .sink(receiveValue: { [weak self] in
                guard
                    let self = self,
                    let history = self.history
                else {
                    return
                }
                self.onDeleteButtonTapped.send(history)
            })
            .store(in: &bindings)
    }
}
