//
//  Cocktails.swift
//  Cocktails
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation

class Cocktails {
    var completion: (() -> Void)!
    
    private let restAgent: RestAgent
    private var cocktails: [CocktailDetails]
    
    init(restService: RestService) {
        restAgent = RestAgent(restService: restService, siteName: "filter.php")
        
        cocktails = []
    }
    
    func getCocktail(from category: String) {
        let completion = { (cocktailsContainer: CocktailContainer<CocktailDetails>) in
            self.cocktails = cocktailsContainer.drinks
            self.completion()
        }
        restAgent.getElements(urlQueryItems: [URLQueryItem(name: "c", value: category)], completion: completion)
    }
    
    func getImage(ofCocktailAt index: Int, completion: @escaping (Data?) -> Void) {
        restAgent.getImage(cocktail: cocktails[index], completion: completion)
    }
    
    func getNumberOfCocktails() -> Int {
        return cocktails.count
    }
    
    func getCocktailName(at index: Int) -> String {
        return cocktails[index].strDrink
    }
}
