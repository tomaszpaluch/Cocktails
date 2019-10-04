//
//  RestService.swift
//  Cocktails
//
//  Created by tomaszpaluch on 03/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation

class RestService {
    var errorCompletion: ((Result<Int, CocktailError>) -> Void)!
    
    private let cache: Cache
    private let serviceURL: URL
    
    init() {
        cache = Cache()
        serviceURL = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/")!
        
        cache.fetchCategories()
        cache.fetchImageData()
    }
    
    func makeInquiry<T: Codable>(url: (site:String, params: [URLQueryItem]?), completion: @escaping (T) -> Void) {
        let url = createActualURL(url.site, with: url.params)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            guard let dataResponse = data, error == nil else {
                self.errorCompletion(.failure(.internetConnectionError))
                self.fetchCategories(completion: completion)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(T.self, from: dataResponse)
                
                completion(responseModel)
                self.saveCategories(responseModel)
                
            } catch {
                self.errorCompletion(.failure(.serviceConnectionError))
                print("JSON Serialization error \n\(error)")
            }
        }.resume()
    }
    
    private func createActualURL(_ page: String, with queryItems: [URLQueryItem]?) -> URL {
        var urlComponents = URLComponents(string: serviceURL.absoluteString + page)!
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
    
    private func fetchCategories<T: Codable>(completion: @escaping (T) -> Void) {
        if T.self is CocktailContainer<CocktailCategory>.Type {
            let categories = self.cache.getCategories()
            let container = CocktailContainer<CocktailCategory>(drinks: categories)

            if let responseModel = container as? T {
                completion(responseModel)
            }
        }
    }
    
    private func saveCategories<T:Codable>(_ responseModel: T) {
        if let responseModel = responseModel as? CocktailContainer<CocktailCategory> {
            self.cache.saveCategories(categories: responseModel.drinks)
        }
    }
    
    func getImage(cocktail: CocktailDetails, completion: @escaping (Data?) -> Void) {
        let cocktailID = Int(cocktail.idDrink)!
        
        DispatchQueue.global().async {
            do {
                let contentURL = URL(string: cocktail.strDrinkThumb)!
                let data = try Data(contentsOf: contentURL)
                
                completion(data)
                self.cache.saveImageData(cocktailID: cocktailID, imageData: data)
            }
                
            catch {
                self.errorCompletion(.failure(.imageLoadingError))
                print("Image loading error \n\(error)")
                
                let imageData = self.cache.getImageData(cocktailID: cocktailID)
                completion(imageData)
            }
        }
    }
}
