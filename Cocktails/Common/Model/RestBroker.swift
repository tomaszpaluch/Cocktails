import Foundation

class RestBroker {
    private let restService: RestService
    
    private let siteName: String
    private let urlQueryItems: [URLQueryItem]?
    
    init(restService: RestService, siteName: String, urlQueryItems: [URLQueryItem]? = nil) {
        self.restService = restService
        
        self.siteName = siteName
        self.urlQueryItems = urlQueryItems
    }
    
    func getElements<T: Codable>(
        urlQueryItems: [URLQueryItem],
        completion: @escaping (Result<T, CocktailError>) -> Void
    ) {
        restService.makeInquiry(url: (siteName, urlQueryItems), completion: completion)
    }
    
    func getElements<T: Codable>(
        completion: @escaping (Result<T, CocktailError>) -> Void
    ) {
        restService.makeInquiry(url: (siteName, urlQueryItems), completion: completion)
    }
}
