import Combine
import Foundation

protocol BaseParameter {
    var parameters: [String: String] { get }
}

struct EmptyParameter: BaseParameter {
    var parameters: [String: String] { [:] }
}

protocol BaseComponent {}

struct EmptyComponent: BaseComponent {}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIError: LocalizedError {
    case server(Int)
    case decode
    case other(String)

    var errorDescription: String? {
        switch self {
            case .server(let code):
                return "\(code) error"

            case .decode:
                return "decode error"

            case .other(let message):
                return message

        }
    }
}

protocol BaseRequest {
    associatedtype Parameter: BaseParameter
    associatedtype Component: BaseComponent
    associatedtype Response: BaseResponse

    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: Parameter { get }
    var component: Component { get }
    
    init(
        parameter: Parameter,
        component: Component
    )
}

extension BaseRequest {

    var baseUrl: String { "https://api.twitter.com/2/" }

    var request: URLRequest? {
        
        var component = URLComponents(string: baseUrl + path)
        component?.queryItems = queryItems
        guard let url = component?.url else { return nil }
            
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.allHTTPHeaderFields = ["Authorization" : "Bearer \(Tokens.twitterBearerToken)"]
        return request
    }
    
    private var queryItems: [URLQueryItem] {
        self.parameter.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }

    var publisher: AnyPublisher<Response, APIError> {
        guard let request = self.request else { return Fail(error: APIError.other("Request error")).eraseToAnyPublisher() }

        print("\n---------- API request ----------")
        print("\(String(describing: request.url?.absoluteString))")
        print("\(String(describing: parameter.parameters))")
        print("--------------------------------\n")

        let session = URLSession(configuration: .default)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(.iso8601)
        
        return session.dataTaskPublisher(for: request)
            .mapError { error -> APIError in
                return APIError.other(error.localizedDescription)
            }
            .tryMap { (data, response) -> Data in
                if
                    let response = response as? HTTPURLResponse,
                    response.statusCode != 200
                {
                    print("Error: invalid HTTP response code \(response.statusCode)")
                    throw APIError.server(response.statusCode)
                }
                return data
            }
            .decode(type: Response.self, decoder: decoder)
            .mapError { error -> APIError in
                return APIError.decode
            }
            .compactMap {
                print("\n---------- API response ----------")
                print($0)
                print("---------------------------------\n")

                return $0
            }
            .eraseToAnyPublisher()
    }
}
