import Combine
import UIKit

extension UISegmentedControl {
    private var segmentedValueChanged: NSNotification.Name { NSNotification.Name(rawValue: "segmentedValueChanged") }
    
    func valuePublisher() -> AnyPublisher<Int, Never> {
        self.addTarget(
            self,
            action: #selector(self.segmentedChanged),
            for: .valueChanged
        )
        return NotificationCenter.default
            .publisher(for: segmentedValueChanged)
            .compactMap { $0.object as? UISegmentedControl }
            .map { $0.selectedSegmentIndex }
            .eraseToAnyPublisher()
    }
    
    @objc private func segmentedChanged() {
        NotificationCenter.default.post(name: segmentedValueChanged, object: self)
    }
}
