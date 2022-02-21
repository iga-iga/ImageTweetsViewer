struct GetSearchResponse: BaseResponse {
    var data: [SearchData]?
    var includes: Includes?
}

extension GetSearchResponse {
    struct SearchData: Codable, Equatable {
        let attachments: Attachments?
        let id: String
        let text: String
    }
    
    struct Attachments: Codable, Equatable {
        let mediaKeys: [String]?
    }
    
    struct Includes: Codable, Equatable {
        let media: [Media]?
    }
    
    struct Media: Codable, Equatable {
        let url: String?
        let mediaKey: String?
    }
}
