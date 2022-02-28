import UIKit
import Kingfisher

final class ImageDetailViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
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
        
        self.tableView.dataSource = self
        
        self.tableView.register(ImageDetail.Cells.ImageCell.self, forCellReuseIdentifier: ImageDetail.Cells.ImageCell.identifier)
    }
}

extension ImageDetailViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        self.viewModel.viewData.imageUrls.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(
            withIdentifier: ImageDetail.Cells.ImageCell.identifier,
            for: indexPath
        )
        
        guard
            let imageCell = cell as? ImageDetail.Cells.ImageCell,
            let url = self.viewModel.getUrl(indexPath.row)
        else {
            return UITableViewCell()
        }
        imageCell.update(viewData: .init(imageUrl: url))
        
        return cell
    }
}
