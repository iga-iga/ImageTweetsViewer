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
        
        self.setupBindings()
        self.registerTableViewCell()
    }
    
    private func setupBindings() {
        self.viewModel.onDeleteHistory
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &bindings)
        
        self.viewModel.onSearchDataChanged
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                self?.searchBar.searchTextField.text = text
                self?.tableView.reloadData()
            })
            .store(in: &bindings)
    }
    
    private func registerTableViewCell() {
        self.tableView.register(
            UINib(
                nibName: "SearchFilterTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: SearchFilterTableViewCell.identifier
        )
        self.tableView.register(
            UINib(
                nibName: "SearchHistoryTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: SearchHistoryTableViewCell.identifier
        )
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @objc private func onTapBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false)
    }
}

extension SearchDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
        self.viewModel.search(searchBar.text ?? "")
        self.dismiss(animated: false)
    }
}

extension SearchDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case 0:
            return "検索条件"
            
        case 1:
            return "検索履歴"
            
        default:
            return ""
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return self.viewModel.querys.count
            
        case 1:
            return self.viewModel.history.count
            
        default:
            return 0
        }
        
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(
                withIdentifier: SearchFilterTableViewCell.identifier,
                for: indexPath
            )
            
            if
                let cell = cell as? SearchFilterTableViewCell,
                let query = self.viewModel.querys.any(indexPath.row)
            {
                cell.set(.init(indexKey: indexPath.row, query: query))
                cell.onViewDataChanged
                    .sink(receiveValue: { viewData in
                        self.viewModel.update(
                            index: viewData.indexKey,
                            query: .init(
                                isActive: viewData.query.isActive,
                                key: viewData.query.key,
                                value: viewData.query.value
                            )
                        )
                    })
                    .store(in: &bindings)
            }
            
            return cell
            
        case 1:
            let cell = self.tableView.dequeueReusableCell(
                withIdentifier: SearchHistoryTableViewCell.identifier,
                for: indexPath
            )
            
            if
                let cell = cell as? SearchHistoryTableViewCell,
                let history = self.viewModel.history.any(indexPath.row)
            {
                cell.set(history)
                cell.onDeleteButtonTapped
                    .sink(receiveValue: { history in
                        self.viewModel.deleteHistory(history)
                    })
                    .store(in: &bindings)
            }
            
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
}
    
extension SearchDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0 :
            return false
            
        default:
            return true
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            self.viewModel.selectHistory(index: indexPath.row)
            
        default:
            break
            
        }
    }
}
