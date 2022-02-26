import Combine

final class SearchViewModel {
    
    let repository = TweetsRepository()
    @Published private(set) var latestUrls: [String] = []
    private var bindings = Set<AnyCancellable>()

    init() {
        self.repository.$latestTweets
            .sink(receiveValue: { [weak self] tweets in
                self?.latestUrls = tweets.map { $0.imageUrls.first ?? "" }
            })
            .store(in: &bindings)
    }
    
    func search(text: String) {
        self.repository.searchLatestTweets(text: text)
    }
}
