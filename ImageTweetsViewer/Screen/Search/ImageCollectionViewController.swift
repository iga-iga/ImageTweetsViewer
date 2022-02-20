import Combine
import UIKit

final class ImageCollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let viewModel = ImageCollectionViewModel()
    private var bindings = Set<AnyCancellable>()

    static func createViewController(index: Int) -> ImageCollectionViewController {
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
        self.setupBind()
        self.viewModel.search()
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
    
    private func setupBind() {
        viewModel.$urls
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self]_ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            })
            .store(in: &bindings)
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
