import Combine
import UIKit

final class SearchFilterTableViewCell: UITableViewCell {
    
    struct ViewData {
        let indexKey: Int
        var query: SearchDetailViewModel.Query
    }
    
    @IBOutlet private weak var activateSwitch: UISwitch!
    @IBOutlet private weak var keyTextField: UITextField!
    @IBOutlet private weak var valueTextField: UITextField!
    
    private var viewData: ViewData?
    
    let onViewDataChanged = PassthroughSubject<ViewData, Never>()

    private var bindings = Set<AnyCancellable>()
    
    func set(_ viewData: ViewData) {
        self.viewData = viewData
        
        self.activateSwitch.isOn = viewData.query.isActive
        self.keyTextField.text = viewData.query.key
        self.valueTextField.text = viewData.query.value
        
        self.activateSwitch.addTarget(
            self,
            action: #selector(switchChanged(_:)),
            for: .valueChanged
        )
        
        self.keyTextField.textPublisher()
            .sink(receiveValue: {[weak self] key in
                guard let self = self else { return }
                self.viewData?.query.key = key
                guard let viewData = self.viewData else { return }
                self.onViewDataChanged.send(viewData)
            })
            .store(in: &bindings)
        
        self.valueTextField.textPublisher()
            .sink(receiveValue: {[weak self] value in
                guard let self = self else { return }
                self.viewData?.query.value = value
                guard let viewData = self.viewData else { return }
                self.onViewDataChanged.send(viewData)
            })
            .store(in: &bindings)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        self.viewData?.query.isActive = sender.isOn
        guard let viewData = self.viewData else { return }
        self.onViewDataChanged.send(viewData)
    }
}
