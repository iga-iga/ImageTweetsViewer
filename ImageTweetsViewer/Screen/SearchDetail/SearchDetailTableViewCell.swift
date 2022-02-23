import Combine
import UIKit

final class SearchDetailTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var activateSwitch: UISwitch!
    @IBOutlet private weak var keyTextField: UITextField!
    @IBOutlet private weak var valueTextField: UITextField!
    
    @Published var viewData = SearchDetailViewModel.Query(
        isActive: false,
        key: "",
        value: ""
    )
    
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
                self?.viewData.key = key
            })
            .store(in: &bindings)
        
        self.valueTextField.textPublisher()
            .sink(receiveValue: {[weak self] value in
                self?.viewData.value = value
            })
            .store(in: &bindings)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        self.viewData.isActive = sender.isOn
    }
}
