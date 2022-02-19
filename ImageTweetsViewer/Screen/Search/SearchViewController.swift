import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )

    private var controllers: [UIViewController] = [
        ImageCollectionViewController.createViewController(index: 1),
        ImageCollectionViewController.createViewController(index: 2),
        ImageCollectionViewController.createViewController(index: 3)
    ]

    private var segmentedItems = ["1", "2", "3"]

    private var currentIndex = 0

    static func createViewController() -> SearchViewController {
        SearchViewController.init(nibName: "SearchViewController", bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.title = "Search"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Remove the top and bottom lines for searchBar
        self.searchBar.backgroundImage = UIImage()
        
        self.view.addSubview(pageViewController.view)
        self.pageViewController.view.frame = self.pageContainerView.frame
        self.pageViewController.setViewControllers(
            [self.controllers.first!],
            direction: .forward,
            animated: false
        )
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        self.segmentedControl.removeAllSegments()
        self.segmentedItems.forEach {
            self.segmentedControl.insertSegment(
                withTitle: $0,
                at: self.segmentedItems.count,
                animated: false
            )
        }
        self.segmentedControl.selectedSegmentIndex = currentIndex
        self.segmentedControl.addTarget(
            self,
            action: #selector(self.segmentedChanged(_:)),
            for: .valueChanged
        )
    }

    @objc private func segmentedChanged(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        guard let viewController = self.controllers.any(index) else { return }
        
        self.pageViewController.setViewControllers(
            [viewController],
            direction: currentIndex < index ? .forward : .reverse,
            animated: true,
            completion: nil
        )

        self.currentIndex = index
    }
}

extension SearchViewController: UIPageViewControllerDataSource {
   func presentationCount(for pageViewController: UIPageViewController) -> Int {
       self.controllers.count
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.controllers.firstIndex(of: viewController),
            let viewController = self.controllers.any(index - 1)
        else {
            return nil
        }
        return viewController
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.controllers.firstIndex(of: viewController),
            let viewController = self.controllers.any(index + 1)
        else {
            return nil
        }
        return viewController
    }
}

extension SearchViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ viewController: UIPageViewController,
        didFinishAnimating: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted: Bool
    ) {
        guard
            let currentViewController = viewController.viewControllers?.first,
            let currentIndex = self.controllers.firstIndex(of: currentViewController)
        else {
            return
        }
        self.segmentedControl.selectedSegmentIndex = currentIndex
        self.currentIndex = currentIndex
    }
}