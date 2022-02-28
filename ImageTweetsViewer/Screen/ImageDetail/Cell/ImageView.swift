import UIKit
import Kingfisher

extension ImageDetail {
    struct ImageViewData: ImageDetailComponentData {
        let imageUrl: String
    }
    
    final class ImageView: UIImageView, ImageDetailComponent {
        typealias ViewData = ImageViewData
        
        func update(viewData: ViewData) {
            guard let url = URL(string: viewData.imageUrl) else { return }
            
            self.kf.setImage(
                with: url,
                placeholder: Image.loadingImage
            ) { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .success(let result):
                    let viewWidth = self.frame.width
                    let height = viewWidth * result.image.size.height / result.image.size.width
                    self.heightAnchor.constraint(equalToConstant: height).isActive = true
                    
                case .failure:
                    break
                }
            }
        }
    }
}
