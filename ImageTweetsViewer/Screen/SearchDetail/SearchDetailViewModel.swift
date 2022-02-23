import Combine

final class SearchDetailViewModel {
    struct Query {
        var isActive: Bool
        var key: String
        var value: String
    }
    
    @Published private(set) var searchText: String = ""
    @Published private(set) var querys: [Query]
    
    private var bindings = Set<AnyCancellable>()
    
    init() {
        self.querys = LocalData.shared.searchQuerys.map { query in
                .init(isActive: query.isActive, key: query.key, value: query.value)
        }
        
        self.$querys
            .sink(receiveValue: { querys in
                LocalData.shared.searchQuerys = querys.map { query in
                        .init(isActive: query.isActive, key: query.key, value: query.value)
                }
            })
            .store(in: &bindings)
    }
    
    func search(text: String) {
        var additionalText = ""
        self.querys.forEach { query in
            if query.isActive {
                additionalText += " \(query.key):\(query.value)"
            }
        }
        self.searchText = text + additionalText
    }
    
    func update(
        index: Int,
        query: Query
    ) {
        guard let _ = querys.any(index) else { return }
        self.querys[index] = query
    }
}
