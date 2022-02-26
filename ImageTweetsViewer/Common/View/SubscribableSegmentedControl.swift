import Combine
import UIKit

final class SubscribableSegmentedControl: UISegmentedControl {
    private let publisher = PassthroughSubject<Int, Never>()
    
    func valuePublisher() -> AnyPublisher<Int, Never> {
        self.addTarget(
            self,
            action: #selector(self.segmentedChanged),
            for: .valueChanged
        )
        return self.publisher.eraseToAnyPublisher()
    }
    
    @objc private func segmentedChanged() {
        self.publisher.send(self.selectedSegmentIndex)
    }
}
