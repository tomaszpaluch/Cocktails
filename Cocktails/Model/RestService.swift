//
//  RestService.swift
//  Cocktails
//
//  Created by tomaszpaluch on 03/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation

class RestService {
    public var getCategoryCompletion: (() -> Void)!
    public var getCocktailsCompletion: (() -> Void)!
    
    private let serviceURL: URL
    private var categories: [CocktailCategory]
    private var cocktails: [CocktailDetails]
    
    private var currentCategoryIndex: Int
    
    init() {
        serviceURL = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/")!
        currentCategoryIndex = 0
        
        categories = []
        cocktails = []
    }
    
    func getCategories() {
        let serviceURL = createActualURL("list.php", with: [URLQueryItem(name: "c", value: "list")])
        let completion = { (categoriesContainer: CocktailContainer<CocktailCategory>) in
            self.categories = categoriesContainer.drinks
            self.getCategoryCompletion()
        }
        
        makeInquiry(url: serviceURL, completion: completion)
    }
    
    func getCocktails(from category: String) {
        let serviceURL = createActualURL("filter.php", with: [URLQueryItem(name: "c", value: category)])
        let completion = { (cocktailsContainer: CocktailContainer<CocktailDetails>) in
            self.cocktails = cocktailsContainer.drinks
            self.getCocktailsCompletion()
        }
        
        makeInquiry(url: serviceURL, completion: completion)
    }
    
    private func createActualURL(_ page: String, with queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents(string: serviceURL.absoluteString + page)!
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
    
    private func makeInquiry<T: Codable>(url: URL, completion: @escaping (T) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            guard let dataResponse = data, error == nil else {
                    //self.errorMessage(error!)
                    return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(T.self, from: dataResponse)
                
                completion(responseModel)
            } catch {
                print("JSON Serialization error \n\(error)")
                //self.errorMessage(error)
            }
        }.resume()
    }
    
    func getNumberOfCategories() -> Int {
        return categories.count
    }
    
    func getCategoryName(at index: Int) -> String {
        return categories[index].strCategory
    }
    
    func setNewCurrentCategory(index: Int) {
        categories[currentCategoryIndex].isCurrent = nil
        categories[index].isCurrent = true
        currentCategoryIndex = index
    }
    
    func isCurrentCategory(categoryIndex: Int) -> Bool {
        return currentCategoryIndex == categoryIndex
    }
    
    func getNumberOfCocktails() -> Int {
        return cocktails.count
    }
    
    func getCocktailName(at index: Int) -> String {
        return cocktails[index].strDrink
    }
    
    func getImage(ofCocktailAt index: Int, completion: @escaping (Data) -> Void) {
        let contentURL = URL(string: cocktails[index].strDrinkThumb)!
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: contentURL)
                completion(data)
            }
            catch {
                print("Image loading error \n\(error)")
            }
        }
    }
}
