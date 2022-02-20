import Combine

class ImageCollectionViewModel {
    
    private var repository = TweetsRepository()
    
    @Published var urls: [String] = []
    
    func search() {
        repository.getTweets(
            query: "ラーメン"
        ) { tweets in
            self.urls = tweets.urls
        }
    }
}
