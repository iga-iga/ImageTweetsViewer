import Combine

class ImageCollectionViewModel {
    
    private(set) var urls: [String] = []
    
    func update(urls: [String]) {
        self.urls = urls
    }
}
