import Combine
import UIKit

final class SearchFilterTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var activateSwitch: UISwitch!
    @IBOutlet private weak var keyTextField: UITextField!
    @IBOutlet private weak var valueTextField: UITextField!
    
    private var viewData = SearchDetailViewModel.Query(
        isActive: false,
        key: "",
        value: ""
    )
    
    let onViewDataChanged = PassthroughSubject<SearchDetailViewModel.Query, Never>()

    private var bindings = Set<AnyCancellable>()
    
    func set(_ viewData: SearchDetailViewModel.Query) {
        self.viewData = viewData
        
        self.activateSwitch.isOn = viewData.isActive
        self.keyTextField.text = viewData.key
        self.valueTextField.text = viewData.value
        
        self.activateSwitch.addTarget(
            self,
            action: #selector(switchChanged(_:)),
            for: .valueChanged
        )
        
        self.keyTextField.textPublisher()
            .sink(receiveValue: {[weak self] key in
                guard let self = self else { return }
                self.viewData.key = key
                self.onViewDataChanged.send(self.viewData)
            })
            .store(in: &bindings)
        
        self.valueTextField.textPublisher()
            .sink(receiveValue: {[weak self] value in
                guard let self = self else { return }
                self.viewData.value = value
                self.onViewDataChanged.send(self.viewData)
            })
            .store(in: &bindings)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        self.viewData.isActive = sender.isOn
        self.onViewDataChanged.send(self.viewData)
    }
}
