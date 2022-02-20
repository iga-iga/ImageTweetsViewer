import Combine

struct DataManager<R: BaseRequest> {
    private var bindings = Set<AnyCancellable>()
    
    mutating func request(
        parameter: R.Parameter,
        component: R.Component,
        completion: @escaping (Result<R.Response, APIError>) -> Void
    ) {
        let request = R(parameter: parameter, component: component)
        
        request.publisher.sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                    
                case let .failure(error):
                    completion(.failure(error))
                    
                }
            },
            receiveValue: { response in
                completion(.success(response))
            }
        ).store(in: &self.bindings)
    }
}
