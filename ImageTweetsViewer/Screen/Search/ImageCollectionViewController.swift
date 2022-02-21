import UIKit

final class ImageCollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    let viewModel = ImageCollectionViewModel()

    static func createViewController() -> ImageCollectionViewController {
        ImageCollectionViewController(
            nibName: "ImageCollectionViewController",
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.dataSource = self
        
        collectionView.register(
            UINib(
                nibName: "ImageCollectionViewCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "ImageCollectionViewCell"
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()
        let length = self.collectionView.frame.width / 2

        layout.itemSize = CGSize(width: length, height: length)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = layout
    }
    
    func update(urls: [String]) {
        self.viewModel.update(urls: urls)
        guard let collectionView = self.collectionView else { return }
        collectionView.reloadData()
    }
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.viewModel.urls.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ImageCollectionViewCell",
            for: indexPath
        )
        
        if
            let imageCell = cell as? ImageCollectionViewCell,
            let url = self.viewModel.urls.any(indexPath.row)
        {
            imageCell.setup(url: url)
        }
        
        return cell
    }
}
