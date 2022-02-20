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
    }
}
