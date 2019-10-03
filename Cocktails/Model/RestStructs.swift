//
//  RestStructs.swift
//  Cocktails
//
//  Created by tomaszpaluch on 03/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation

struct CocktailContainer<T: Codable>: Codable {
    let drinks: [T]
}

struct CocktailCategory: Codable {
    let strCategory: String
    
    var isCurrent: Bool?
}

struct CocktailDetails: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}

