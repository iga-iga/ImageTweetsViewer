import Combine
import UIKit

final class SearchFilterTableViewCell: UITableViewCell {
    
    struct ViewData {
        let indexKey: Int
        var query: SearchDetailViewModel.Query
    }
    
    @IBOutlet private weak var activateSwitch: SubscribableSwitch!
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

        self.activateSwitch.onSwitchPublisher()
            .sink(receiveValue: { [weak self] isOn in
                guard let self = self else { return }
                self.viewData?.query.isActive = isOn
                guard let viewData = self.viewData else { return }
                self.onViewDataChanged.send(viewData)
            })
            .store(in: &bindings)
        
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
}
