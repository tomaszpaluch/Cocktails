//
//  RestAgent.swift
//  Cocktails
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation

class RestAgent {
    private let restService: RestService
    
    private let siteName: String
    private let urlQueryItems: [URLQueryItem]?
    
    init(restService: RestService, siteName: String, urlQueryItems: [URLQueryItem]? = nil) {
        self.restService = restService
        
        self.siteName = siteName
        self.urlQueryItems = urlQueryItems
    }
    
    func getElements<T: Codable>(urlQueryItems: [URLQueryItem], completion: @escaping (T) -> Void) {
        restService.makeInquiry(url: (siteName, urlQueryItems), completion: completion)
    }
    
    func getElements<T: Codable>(completion: @escaping (T) -> Void) {
        restService.makeInquiry(url: (siteName, urlQueryItems), completion: completion)
    }
    
    func getImage(cocktail: CocktailDetails, completion: @escaping (Data?) -> Void) {
        restService.getImage(cocktail: cocktail, completion: completion)
    }
}
