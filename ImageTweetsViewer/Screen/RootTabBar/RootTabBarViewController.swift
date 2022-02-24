import UIKit

final class RootTabBarViewController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.setViewControllers(
            [
                UINavigationController(
                    rootViewController: SearchViewController.createViewController()
                )
            ],
            animated: false
        )
    }
}
