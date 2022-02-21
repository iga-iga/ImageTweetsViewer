struct TweetsDOM: DomainObjectModel {
    var images: [ImageData]
    var data: [TweetData]
}

extension TweetsDOM {
    struct ImageData: Equatable {
        var url: String
        var mediaKey: String
    }
    
    struct TweetData: Equatable {
        var id: String
        var text: String
        var mediaKeys: [String]
    }
}
