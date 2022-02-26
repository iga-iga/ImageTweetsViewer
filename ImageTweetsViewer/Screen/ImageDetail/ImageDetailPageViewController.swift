import UIKit

final class ImageDetailPageViewController: UIPageViewController {
    
    private let viewModel: ImageDetailPageViewModel
    
    static func createViewController(
        repository: TweetsRepository,
        selectedIndex: Int
    ) -> ImageDetailPageViewController {
        ImageDetailPageViewController(
            repository: repository,
            selectedIndex: selectedIndex
        )
    }

    init(
        repository: TweetsRepository,
        selectedIndex: Int
    ) {
        self.viewModel = .init(
            repository: repository,
            selectedIndex: selectedIndex
        )
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        self.commonInit()
    }
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        self.viewModel = .init(repository: TweetsRepository(), selectedIndex: 0)
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = .init(repository: TweetsRepository(), selectedIndex: 0)
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.title = ""
        self.delegate = self
        self.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let vc = ImageDetailViewController.createViewController(
            viewModel: .init(
                viewData: self.viewModel.getCurrentViewData(),
                selectedIndex: self.viewModel.selectedIndex
            )
        )
        self.setViewControllers(
            [vc],
            direction: .forward,
            animated: false
        )
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension ImageDetailPageViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        self.viewModel.tweetsCount
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewData =  self.viewModel.getBeforeViewData() else { return nil }
        return ImageDetailViewController.createViewController(viewModel: .init(viewData: viewData, selectedIndex: self.viewModel.selectedIndex - 1))
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewData =  self.viewModel.getAfterViewData() else { return nil }
        return ImageDetailViewController.createViewController(viewModel: .init(viewData: viewData, selectedIndex: self.viewModel.selectedIndex + 1))
    }
}

extension ImageDetailPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ viewController: UIPageViewController,
        didFinishAnimating: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted: Bool
    ) {
        guard
            let imageDetailViewController = viewController.viewControllers?.first as? ImageDetailViewController
        else {
            return
        }
        let nextIndex = imageDetailViewController.viewModel.index
        self.viewModel.update(selectedIndex: nextIndex)
    }
}
