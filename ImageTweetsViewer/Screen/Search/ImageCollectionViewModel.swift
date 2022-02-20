import Combine

class ImageCollectionViewModel {
    
    private var repository = TweetsRepository()
    
    @Published var urls: [String] = []
    
    func search(text: String) {
        repository.getTweets(
            query: text
        ) { tweets in
            self.urls = tweets.urls
        }
    }
}
