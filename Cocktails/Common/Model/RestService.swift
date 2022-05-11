import Foundation

class RestService {
    private let serviceURL: URL?
    
    init() {
        serviceURL = URL(
            string: "https://www.thecocktaildb.com/api/json/v1/1/"
        )
    }
    
    func makeInquiry<T: Codable>(
        url: (site: String, params: [URLQueryItem]?),
        completion: @escaping (Result<T, CocktailError>) -> Void)
    {
        if let url = createActualURL(url.site, with: url.params) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error -> Void in
                if let dataResponse = data, error == nil {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let responseModel = try jsonDecoder.decode(T.self, from: dataResponse)

                        completion(.success(responseModel))
                    } catch {
                        completion(.failure(.serviceConnectionError))
                        print("JSON Serialization error \n\(error)")
                    }
                } else {
                    completion(.failure(.internetConnectionError))
                }
            }.resume()
        }
    }
    
    private func createActualURL(_ page: String, with queryItems: [URLQueryItem]?) -> URL? {
        if let serviceURL = serviceURL, var urlComponents = URLComponents(string: serviceURL.absoluteString + page) {
            urlComponents.queryItems = queryItems
            
            return urlComponents.url
        }
        
        return nil
    }
}
