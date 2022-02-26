import Combine
import UIKit

final class SubscribableButton: UIButton {
    
    private let publisher = PassthroughSubject<Void, Never>()
    
    func onTapPublisher() -> AnyPublisher<Void, Never> {
        self.addTarget(
            self,
            action: #selector(self.tapped),
            for: .touchUpInside
        )
        return publisher.eraseToAnyPublisher()
    }
    
    @objc private func tapped() {
        self.publisher.send()
    }
}
