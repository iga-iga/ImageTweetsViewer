struct TweetData {
    let imageUrls: [String]
    let text: String
}

final class TweetsRepository {
    
    private var dataManager = DataManager<GetSearchRequest>()
    private(set) var tweets: [TweetData] = []

    func getLatestTweets(
        text: String,
        completion: @escaping ([TweetData]) -> Void
    ) {
        self.getTweets(query: text) { [weak self] dom in
            var tweets: [TweetData] = []
            dom.data.forEach { data in
                if !data.mediaKeys.isEmpty {
                    let hitImageData = data.mediaKeys.compactMap { mediaKey in
                        dom.images.filter { $0.mediaKey == mediaKey }.first
                    }
                    let imageUrls = hitImageData.map { $0.url }
                    tweets.append(.init(imageUrls: imageUrls, text: data.text))
                }
            }
            self?.tweets = tweets
            completion(tweets)
        }
    }
    
    //  Invalid query for v2 endpoint
//    mutating func getPopularTweets(
//        text: String,
//        completion: @escaping ([TweetData]) -> Void
//    ) {
//        let query = text + " min_faves:10"
//        self.getTweets(query: query) { dom in
//            completion(self.map(dom))
//        }
//    }
    
    private func getTweets(
        query: String,
        completion: @escaping (TweetsDOM) -> Void
    ) {
        dataManager.request(
            parameter: .init(
                query: query + " has:images",
                expansions: "attachments.media_keys",
                mediaFields: "url"
            ),
            component: .init()
        ) { result in
            switch result {
            case .success(let response):
                completion(TweetsMapper().map(response))
                
            case .failure:
                break // TODO: Implement
                
            }
        }
    }
}
