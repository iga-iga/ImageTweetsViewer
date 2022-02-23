import Foundation

struct LocalData {
    
    private enum Key: String {
        case searchQuerys
    }
    
    static var shared = LocalData()
    private var savedSearchQuerys: [SearchQuery] = []
    
    var searchQuerys: [SearchQuery] {
        get {
            savedSearchQuerys
        }
        set {
            savedSearchQuerys = newValue
            if let encodedValue = try? JSONEncoder().encode(savedSearchQuerys) {
                UserDefaults.standard.set(encodedValue, forKey: Key.searchQuerys.rawValue)
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
    }
}

extension LocalData {
    struct SearchQuery: Codable {
        var isActive: Bool
        var key: String
        var value: String
    }
}
