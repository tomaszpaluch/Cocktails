//
//  Categories.swift
//  Cocktails
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation

class Categories {
    var completion: (() -> Void)!
    
    private let restAgent: RestAgent
    private var categories: [CocktailCategory]
    
    private var currentCategoryIndex: Int
    
    init(restService: RestService) {
        restAgent = RestAgent(restService: restService, siteName: "list.php", urlQueryItems: [URLQueryItem(name: "c", value: "list")])
        
        categories = []
        currentCategoryIndex = 0
    }
    
    func getCategories() {
        let completion = { (categoriesContainer: CocktailContainer<CocktailCategory>) in
            self.categories = categoriesContainer.drinks
            self.completion()
        }
        
        restAgent.getElements(completion: completion)
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
}
