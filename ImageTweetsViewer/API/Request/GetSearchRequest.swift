public struct GetSearchRequest: BaseRequest {
    
    init(
        parameter: SearchParameter,
        component: EmptyComponent
    ) {
        self.parameter = parameter
    }
    
    typealias Response = GetSearchResponse

    var method: HTTPMethod { .get }

    var path: String { "tweets/search/recent" }

    struct SearchParameter: BaseParameter {
        var parameters: [String : String]
                
        init(
            query: String,
            expansions: String,
            mediaFields: String,
            maxResults: String = "10"
        ) {
            parameters = [
                "query" : query,
                "expansions" : expansions,
                "media.fields" : mediaFields,
                "max_results": maxResults
            ]
        }
    }
    
    var parameter: SearchParameter
    
    var component = EmptyComponent()
}
