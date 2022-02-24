import UIKit
import Kingfisher

final class ImageDetailViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet var imageViews: [UIImageView]!
    
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
        
        for (index, imageView) in self.imageViews.enumerated() {
            guard
                let url = self.self.viewModel.getUrl(index)
            else {
                imageView.isHidden = true
                continue
            }
            imageView.kf.setImage(
                with: url,
                placeholder: Image.loadingImage
            ) { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .success(let result):
                    let viewWidth = self.view.frame.width
                    let height = viewWidth * result.image.size.height / result.image.size.width
                    imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
                    
                case .failure:
                    break
                }
            }
        }
    }
}
