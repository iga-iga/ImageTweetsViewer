struct TweetsDOM: DomainObjectModel {
    var urls: [String]
    var data: [TweetsDOM.Data]
}

extension TweetsDOM {
    struct Data: Equatable {
        var id: String
        var text: String
    }
}
