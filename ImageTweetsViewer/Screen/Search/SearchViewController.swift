import Combine
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

    private let latestImageCollectionVC = ImageCollectionViewController.createViewController()
    private let popularImageCollectionVC = ImageCollectionViewController.createViewController()
    private var controllers: [UIViewController] {[
        self.latestImageCollectionVC,
        self.popularImageCollectionVC
    ]}

    private var segmentedItems = ["最新", "人気"]

    private var currentIndex = 0
    private let viewModel = SearchViewModel()
    private var bindings = Set<AnyCancellable>()

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
        self.setupBind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    private func setupViews() {
        // Remove the top and bottom lines for searchBar
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
        self.searchBar.enablesReturnKeyAutomatically = false
        
        self.view.addSubview(pageViewController.view)
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageViewController.view.topAnchor.constraint(equalTo: self.pageContainerView.topAnchor),
            self.pageViewController.view.leftAnchor.constraint(equalTo: self.pageContainerView.leftAnchor),
            self.pageViewController.view.rightAnchor.constraint(equalTo: self.pageContainerView.rightAnchor),
            self.pageViewController.view.bottomAnchor.constraint(equalTo: self.pageContainerView.bottomAnchor)
        ])
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
        self.segmentedControl.valuePublisher()
            .sink(receiveValue: { [weak self] index in
                self?.segmentedChanged(index)
            })
            .store(in: &bindings)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func segmentedChanged(_ index: Int) {
        guard let viewController = self.controllers.any(index) else { return }
        
        self.pageViewController.setViewControllers(
            [viewController],
            direction: currentIndex < index ? .forward : .reverse,
            animated: true,
            completion: nil
        )

        self.currentIndex = index
    }
    
    private func setupBind() {
        viewModel.$latestUrls
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] urls in
                guard let self = self else { return }
                self.latestImageCollectionVC.update(urls: urls)
            })
            .store(in: &bindings)
        
        self.latestImageCollectionVC.onImageSelected
            .sink(receiveValue: { [weak self] index in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    ImageDetailPageViewController.createViewController(
                        repository: self.viewModel.repository,
                        selectedIndex: index
                    ),
                    animated: true
                )
            })
            .store(in: &bindings)
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        let viewController = SearchDetailViewController.createViewController()
        
        viewController.viewModel.onSearch
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] searchText in
                guard
                    let self = self,
                    !searchText.isEmpty
                else {
                    return
                }
                self.viewModel.search(text: searchText)
            })
            .store(in: &bindings)
        
        self.present(viewController, animated: false)
    }
}
