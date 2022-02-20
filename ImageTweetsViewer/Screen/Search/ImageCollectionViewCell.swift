import UIKit
import Kingfisher

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(url: String) {
        guard let url = URL(string: url) else { return }
        self.imageView.kf.setImage(with: url)
    }
}
