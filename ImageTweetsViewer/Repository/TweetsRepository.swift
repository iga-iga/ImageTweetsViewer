struct TweetData {
    let imageUrls: [String]
    let text: String
}

struct TweetsRepository {
    var dataManager = DataManager<GetSearchRequest>()
    
    mutating func getTweets(
        text: String,
        completion: @escaping ([TweetData]) -> Void
    ) {
        self.getTweets(query: text) { dom in
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
            
            completion(tweets)
        }
    }
    
    private mutating func getTweets(
        query: String,
        completion: @escaping (TweetsDOM) -> Void
    ) {
        self.dataManager.request(
            parameter: .init(
                query: query,
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
