import UIKit
import Kingfisher

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.kf.cancelDownloadTask()
        self.imageView.image = Image.loadingImage
    }
    
    func setup(url: String) {
        guard let url = URL(string: url) else { return }

        self.imageView.kf.setImage(with: url, placeholder: Image.loadingImage)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true

        self.imageView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        self.imageView.layer.borderWidth = 1
    }
}
