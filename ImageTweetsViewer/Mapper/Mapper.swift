protocol Mapper {
    associatedtype Response: BaseResponse
    associatedtype DOM: DomainObjectModel
    
    func map(_ response: Response) -> DOM
}
