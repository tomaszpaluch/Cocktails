//
//  Mocks.swift
//  CocktailsTests
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation
@testable import Cocktails

class RestServiceMock: RestService {
    override init() {
        super.init()
    }
    
    override func makeInquiry<T: Codable>(url: (site:String, params: [URLQueryItem]?), completion: @escaping (T) -> Void) {
        let url = createActualURL(url.site, with: url.params)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            guard let dataResponse = data, error == nil else {
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(T.self, from: dataResponse)
                
                completion(responseModel)
            } catch {
                print("JSON Serialization error \n\(error)")
            }
        }.resume()
    }
    
    private func createActualURL(_ page: String, with queryItems: [URLQueryItem]?) -> URL {
        switch page {
        case "list.php":
            return URL(fileURLWithPath: Bundle.main.path(forResource: "categories", ofType: "json")!)
        case "filter.php":
            switch queryItems![0].value
            {
            case "Ordinary Drink":
                return URL(fileURLWithPath: Bundle.main.path(forResource: "cocktails_ordinary", ofType: "json")!)
            case "Coffee / Tea":
                return URL(fileURLWithPath: Bundle.main.path(forResource: "cocktails", ofType: "json")!)
            default:
                return URL(string: "wp.pl")!
            }
        default:
            return URL(string: "wp.pl")!
        }
    }
}

