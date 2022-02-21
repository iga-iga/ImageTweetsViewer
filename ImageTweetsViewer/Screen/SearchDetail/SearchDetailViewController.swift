import Combine
import UIKit

final class SearchDetailViewController: UIViewController {
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    @Published var searchText: String = ""
    
    private let viewModel = SearchDetailViewModel()
    
    static func createViewController() -> SearchDetailViewController {
        SearchDetailViewController(
            nibName: "SearchDetailViewController",
            bundle: nil
        )
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
        self.title = ""
        self.setupBind()
        modalPresentationStyle = .fullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Remove the top and bottom lines for searchBar
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
        
        self.backButton.setTitle("", for: .normal)
        self.backButton.addTarget(
            self,
            action: #selector(onTapBackButton(_:)),
            for: .touchUpInside
        )
    }
    
    private func setupBind() {
        
    }
    
    @objc private func onTapBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
}

extension SearchDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        self.searchText = searchBar.text ?? ""
        self.dismiss(animated: false)
    }
}
