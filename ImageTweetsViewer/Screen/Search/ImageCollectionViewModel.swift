import Combine

class ImageCollectionViewModel {
    
    private var repository = TweetsRepository()
    
    @Published var urls: [String] = []
    
    func search(text: String) {
        repository.getTweets(
            text: text
        ) { tweets in
            self.urls = tweets.map { $0.imageUrls.first ?? "" }
        }
    }
}
