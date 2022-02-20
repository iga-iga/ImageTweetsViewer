import Combine
import XCTest
@testable import ImageTweetsViewer

class ImageTweetsViewerTests: XCTestCase {
    
    private var bindings = Set<AnyCancellable>()

    func testGetSearch() {
        let query = "テスト"
        let expansions = "attachments.media_keys"
        let mediaFields = "url"
        let expectation = self.expectation(description: "testSearchSuccess")

        GetSearchRequest(
            parameter: .init(
                query: query,
                expansions: expansions,
                mediaFields: mediaFields
            ),
            component: .init()
        ).publisher.sink(
            receiveCompletion: { result in
                switch result {
                    case .finished:
                        expectation.fulfill()

                    case .failure:
                        XCTFail("testSearch failed")

                }
            },
            receiveValue: { response in
                XCTAssertTrue(!response.data.isEmpty)
            }
        ).store(in: &bindings)

        waitForExpectations(timeout: 20, handler: nil)
    }

}
