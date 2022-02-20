struct TweetsMapper: Mapper {
    func map(_ response: GetSearchRequest.Response) -> TweetsDOM {
        TweetsDOM(
            urls: response.includes?.media?.compactMap { $0.url } ?? [],
            data: response.data.map { TweetsDOM.Data(
                id: $0.id,
                text: $0.text
            )}
        )
    }
}
