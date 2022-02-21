struct TweetsMapper: Mapper {
    func map(_ response: GetSearchRequest.Response) -> TweetsDOM {
        TweetsDOM(
            images: response.includes?.media?.compactMap { TweetsDOM.ImageData(
                url: $0.url ?? "",
                mediaKey: $0.mediaKey ?? ""
            )} ?? [],
            data: response.data?.compactMap { TweetsDOM.TweetData(
                id: $0.id,
                text: $0.text,
                mediaKeys: $0.attachments?.mediaKeys ?? []
            )} ?? []
        )
    }
}
