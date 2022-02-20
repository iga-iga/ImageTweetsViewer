import UIKit

final class ImageCollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

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
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        20
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ImageCollectionViewCell",
            for: indexPath
        )
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.setup()
        }
        
        return cell
    }
}
