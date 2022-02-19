import UIKit

final class ImageCollectionViewController: UIViewController {

    @IBOutlet private weak var label: UILabel!
    private var index = 0

    static func createViewController(index: Int) -> ImageCollectionViewController {
        ImageCollectionViewController.init(
            nibName: "ImageCollectionViewController",
            bundle: nil,
            index: index
        )
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, index: Int) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
        self.index = index
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.title = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.text = "\(index)"
    }
}
