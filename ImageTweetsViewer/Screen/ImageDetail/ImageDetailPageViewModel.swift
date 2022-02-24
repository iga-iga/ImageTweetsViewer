import Combine

final class ImageDetailPageViewModel {
    
    private let repository: TweetsRepository
    private(set) var selectedIndex: Int
    
    var tweetsCount: Int {
        self.repository.tweets.count
    }
    
    init(
        repository: TweetsRepository,
        selectedIndex: Int
    ) {
        self.repository = repository
        self.selectedIndex = selectedIndex
    }
    
    func getCurrentViewData() -> ImageDetailViewModel.ViewData {
        guard
            let tweet = self.repository.tweets.any(selectedIndex)
        else {
            return .init(imageUrls: [], text: "")
        }
        return .init(imageUrls: tweet.imageUrls, text: tweet.text)
    }
    
    func getBeforeViewData() -> ImageDetailViewModel.ViewData? {
        guard
            let tweet = self.repository.tweets.any(self.selectedIndex - 1)
        else {
            return nil
        }
        return .init(imageUrls: tweet.imageUrls, text: tweet.text)
    }
    
    func getAfterViewData() -> ImageDetailViewModel.ViewData? {
        guard
            let tweet = self.repository.tweets.any(self.selectedIndex + 1)
        else {
            return nil
        }
        return .init(imageUrls: tweet.imageUrls, text: tweet.text)
    }
    
    func update(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
    }
}
