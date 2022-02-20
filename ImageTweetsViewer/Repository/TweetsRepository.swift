struct TweetsRepository {
    var dataManager = DataManager<GetSearchRequest>()
    
    mutating func getTweets(
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
