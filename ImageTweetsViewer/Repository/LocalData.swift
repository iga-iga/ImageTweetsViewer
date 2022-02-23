import Foundation

struct LocalData {
    
    private enum Key: String {
        case searchQuerys
        case searchHistory
    }
    
    static var shared = LocalData()
    
    private var savedSearchQuerys: [SearchQuery] = []
    var searchQuerys: [SearchQuery] {
        get {
            self.savedSearchQuerys
        }
        set {
            self.savedSearchQuerys = newValue
            if let encodedValue = try? JSONEncoder().encode(savedSearchQuerys) {
                UserDefaults.standard.set(encodedValue, forKey: Key.searchQuerys.rawValue)
            }
        }
    }
    
    private var savedSearchHistory: [SearchHistory] = []
    var searchHistory: [SearchHistory] {
        get {
            self.savedSearchHistory
        }
        set {
            self.savedSearchHistory = newValue
            if let encodedValue = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedValue, forKey: Key.searchHistory.rawValue)
            }
        }
    }
    
    mutating func initialize() {
        if
            let data = UserDefaults.standard.data(forKey: Key.searchQuerys.rawValue),
            let searchQuerys = try? JSONDecoder().decode([SearchQuery].self, from: data)
        {
            self.searchQuerys = searchQuerys
        } else {
            self.searchQuerys = [
                .init(isActive: true, key: "lang", value: "ja"),
                .init(isActive: false, key: "from", value: ""),
                .init(isActive: false, key: "", value: ""),
                .init(isActive: false, key: "", value: ""),
            ]
        }
        
        if
            let data = UserDefaults.standard.data(forKey: Key.searchHistory.rawValue),
            let searchHistory = try? JSONDecoder().decode([SearchHistory].self, from: data)
        {
            self.searchHistory = searchHistory
        } else {
            self.searchHistory = []
        }
    }
}

extension LocalData {
    struct SearchQuery: Codable {
        var isActive: Bool
        var key: String
        var value: String
    }
    
    struct SearchHistory: Codable {
        var querys: [SearchQuery]
        var searchText: String
    }
}
