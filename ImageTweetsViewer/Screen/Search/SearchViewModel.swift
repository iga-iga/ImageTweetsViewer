import Combine

final class SearchViewModel {
    private var repository = TweetsRepository()
    
    @Published var latestUrls: [String] = []

    func search(text: String) {
        self.repository.getLatestTweets(
            text: text
        ) { tweets in
            self.latestUrls = tweets.map { $0.imageUrls.first ?? "" }
        }
    }
}
