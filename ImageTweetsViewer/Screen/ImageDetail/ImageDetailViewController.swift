import UIKit

final class ImageDetailViewController: UIViewController {
    
    private let viewModel: ImageDetailViewModel
    private let repository: TweetsRepository
    
    static func createViewController(
        repository: TweetsRepository,
        selectedIndex: Int
    ) -> ImageDetailViewController {
        ImageDetailViewController(
            repository: repository,
            selectedIndex: selectedIndex
        )
    }
    
    init(
        repository: TweetsRepository,
        selectedIndex: Int
    ) {
        self.viewModel = .init(selectedIndex: selectedIndex)
        self.repository = repository
        super.init(nibName: "ImageDetailViewController", bundle: nil)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        self.viewModel = .init(selectedIndex: 0)
        self.repository = TweetsRepository()
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
