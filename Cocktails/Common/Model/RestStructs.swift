import Foundation

struct CocktailContainer<T: Codable>: Codable {
    let drinks: [T]
}

struct CocktailCategory: Codable {
    let strCategory: String
    
    var isCurrent: Bool?
}

struct CocktailIndgredient: Codable {
    let strIngredient1: String
}

struct CocktailDetails: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}

