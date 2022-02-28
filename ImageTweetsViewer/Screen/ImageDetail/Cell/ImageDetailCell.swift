import UIKit

struct ImageDetail {}

protocol ImageDetailComponentData {}

protocol ImageDetailComponent: UIView {
    associatedtype ViewData: ImageDetailComponentData
    func update(viewData: ViewData)
}

extension ImageDetail {
    final class Cell<Component: ImageDetailComponent>: UITableViewCell {
        
        let view = Component()
        
        func make() -> Self {
            self.addSubview(view)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.leftAnchor.constraint(equalTo: self.leftAnchor),
                view.rightAnchor.constraint(equalTo: self.rightAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
            return self
        }
        
        func update(viewData: Component.ViewData) {
            self.view.update(viewData: viewData)
        }
    }
}

extension ImageDetail {
    struct Cells {
        var imageDetailCell = Cell<ImageView>()
    }
}
