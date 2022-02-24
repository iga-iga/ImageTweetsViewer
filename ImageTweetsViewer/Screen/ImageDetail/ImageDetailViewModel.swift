import Combine
import Foundation

final class ImageDetailViewModel {
    
    struct ViewData {
        let imageUrls: [String]
        let text: String
    }
    
    let viewData: ViewData
    let index: Int
    
    init(viewData: ViewData, selectedIndex: Int) {
        self.viewData = viewData
        self.index = selectedIndex
    }
    
    func getUrl(_ index: Int) -> URL? {
        guard let url = viewData.imageUrls.any(index) else { return nil }
        return URL(string: url)
    }
}
