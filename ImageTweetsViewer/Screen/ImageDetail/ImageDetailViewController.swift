import UIKit
import Kingfisher

final class ImageDetailViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    let viewModel: ImageDetailViewModel
    
    static func createViewController(
        viewModel: ImageDetailViewModel
    ) -> ImageDetailViewController {
        ImageDetailViewController(
            viewModel: viewModel
        )
    }
    
    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: "ImageDetailViewController",
            bundle: nil
        )
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = .init(viewData: .init(imageUrls: [], text: ""), selectedIndex: 0)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        self.viewModel = .init(viewData: .init(imageUrls: [], text: ""), selectedIndex: 0)
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // temp
        let imageView = UIImageView()
        self.stackView.addArrangedSubview(imageView)
        imageView.kf.setImage(
            with: self.viewModel.getUrl(0),
            placeholder: Image.loadingImage
        )
    }
}
