import Combine
import UIKit

final class SearchDetailViewController: UIViewController {
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
        
    let viewModel = SearchDetailViewModel()
    private var bindings = Set<AnyCancellable>()
    
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
        modalPresentationStyle = .fullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Remove the top and bottom lines for searchBar
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
        self.searchBar.becomeFirstResponder()
        
        self.backButton.setTitle("", for: .normal)
        self.backButton.addTarget(
            self,
            action: #selector(onTapBackButton(_:)),
            for: .touchUpInside
        )
        
        self.tableView.register(
            UINib(
                nibName: "SearchDetailTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "SearchDetailTableViewCell"
        )
        self.tableView.dataSource = self
    }
    
    @objc private func onTapBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
}

extension SearchDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
        self.viewModel.search(text: searchBar.text ?? "")
        self.dismiss(animated: false)
    }
}

extension SearchDetailViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        self.viewModel.querys.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(
            withIdentifier: "SearchDetailTableViewCell",
            for: indexPath
        )
        
        if
            let imageCell = cell as? SearchDetailTableViewCell,
            let query = self.viewModel.querys.any(indexPath.row)
        {
            imageCell.set(query)
            
            imageCell.$viewData
                .sink(receiveValue: { viewData in
                    self.viewModel.update(
                        index: indexPath.row,
                        query: .init(
                            isActive: viewData.isActive,
                            key: viewData.key,
                            value: viewData.value
                        )
                    )
                })
                .store(in: &bindings)
        }
        
        return cell
    }
}
