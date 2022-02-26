import Combine
import UIKit

final class SubscribableSwitch: UISwitch {
    
    private let publisher = PassthroughSubject<Bool, Never>()

    func onSwitchPublisher() -> AnyPublisher<Bool, Never> {
        self.addTarget(
            self,
            action: #selector(self.changed),
            for: .valueChanged
        )
        return self.publisher.eraseToAnyPublisher()
    }
    
    @objc private func changed() {
        self.publisher.send(self.isOn)
    }
}
