import Combine

final class SearchDetailViewModel {
    struct Query: Equatable {
        var isActive: Bool
        var key: String
        var value: String
        
        var isValidated: Bool {
            isActive && !key.isEmpty && !value.isEmpty
        }
    }
    
    struct History: Equatable {
        var querys: [Query]
        var searchText: String
    }
    
    @Published private(set) var searchText: String = ""
    @Published private(set) var querys: [Query] = []
    @Published private(set) var history: [History] = []
    
    let onDeleteHistory = PassthroughSubject<Void, Never>()
    let onSearch = PassthroughSubject<String, Never>()
    let onSearchDataChanged = PassthroughSubject<String, Never>()
    
    private var bindings = Set<AnyCancellable>()
    
    init() {
        self.querys = self.map(LocalData.shared.searchQuerys)
        
        self.history = LocalData.shared.searchHistory.map { history in
                .init(querys: self.map(history.querys), searchText: history.searchText)
        }
        
        self.$querys
            .sink(receiveValue: { [weak self] querys in
                guard let self = self else { return }
                LocalData.shared.searchQuerys = self.map(querys)
            })
            .store(in: &bindings)
        
        self.$history
            .sink(receiveValue: { [weak self] history in
                guard let self = self else { return }
                LocalData.shared.searchHistory = history.map {
                        .init(querys: self.map($0.querys), searchText: $0.searchText)
                }
            })
            .store(in: &bindings)
    }
    
    func search(_ text: String) {
        var additionalText = ""
        self.querys.forEach { query in
            if query.isValidated {
                additionalText += " \(query.key):\(query.value)"
            }
        }
        self.onSearch.send(text + additionalText)
        self.addHistory(.init(querys: self.querys, searchText: text))
    }
    
    func update(
        index: Int,
        query: Query
    ) {
        guard let _ = querys.any(index) else { return }
        self.querys[index] = query
    }
    
    func deleteHistory(
        _ history: History
    ) {
        self.history.removeAll(where: { $0 == history } )
        self.onDeleteHistory.send()
    }
    
    func selectHistory(index: Int) {
        guard let history = history.any(index) else { return }
        self.searchText = history.searchText
        self.querys = history.querys
        self.onSearchDataChanged.send(history.searchText)
    }
    
    private func map(_ querys: [LocalData.SearchQuery]) -> [Query] {
        querys.map { query in
                .init(isActive: query.isActive, key: query.key, value: query.value)
        }
    }
    
    private func map(_ querys: [Query]) -> [LocalData.SearchQuery] {
        querys.map { query in
                .init(isActive: query.isActive, key: query.key, value: query.value)
        }
    }
    
    private func addHistory(_ history: History) {
        if !self.history.contains(history) {
            self.history.append(history)
        }
    }
}
