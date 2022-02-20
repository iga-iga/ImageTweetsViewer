import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        self.imageView.layer.borderColor = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
        self.imageView.layer.borderWidth = 2
    }
}
