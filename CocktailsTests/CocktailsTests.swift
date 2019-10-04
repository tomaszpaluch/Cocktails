//
//  CocktailsTests.swift
//  CocktailsTests
//
//  Created by tomaszpaluch on 03/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import XCTest
@testable import Cocktails

class CocktailsTests: XCTestCase {
    var categories: Categories!
    var cocktails: Cocktails!
    
    var categoriesWait = true
    var cocktailsWait = true
    
    let categoryIndex = 0
    
    override func setUp() {
        let restService = RestServiceMock()
        
        categories = Categories(restService: restService)
        cocktails = Cocktails(restService: restService)
        
        categories.completion = {[unowned self] in
            let categoryIndex = self.categoryIndex
            self.categoriesWait = false
            
            let categoryName = self.categories.getCategoryName(at: categoryIndex)
            self.categories.setNewCurrentCategory(index: categoryIndex)
            self.cocktails.getCocktail(from: categoryName)
        }
        
        cocktails.completion = {[unowned self] in
            self.cocktailsWait = false
        }
        
        categories.getCategories()
    }

    override func tearDown() {}
    
    func testGetCategoriesCount_Standard_Returns11() {
        while categoriesWait {}
        
        let categoriesCount = categories.getNumberOfCategories()
        print(categoriesCount)
        XCTAssertEqual(categoriesCount, 11)
    }
    
    func testGetCategoryName_First_ReturnsOrdinaryDrink() {
        while categoriesWait {}
        
        let firstCategoryName = categories.getCategoryName(at: 0)
        print(firstCategoryName)
        XCTAssertEqual(firstCategoryName, "Ordinary Drink")
    }
    
    func testGetCategoryName_Last_ReturnsSoftDrinkSoda() {
        while categoriesWait {}
        
        let categoriesCount = categories.getNumberOfCategories()
        let lastCategoryName = categories.getCategoryName(at: categoriesCount - 1)
        print(lastCategoryName)
        XCTAssertEqual(lastCategoryName, "Soft Drink / Soda")
    }
    
    func testIsCategoryCurrent_FirstAtTheBegining_ReturnsTrue() {
        while categoriesWait {}
        
        let isCurrent = categories.isCurrentCategory(categoryIndex: categoryIndex)
        
        XCTAssertTrue(isCurrent)
    }
    
    func testIsCategoryCurrent_SixthAtTheBegining_ReturnsFalse() {
        while categoriesWait {}
        
        let isCurrent = categories.isCurrentCategory(categoryIndex: 6)
        
        XCTAssertFalse(isCurrent)
    }
    
    func testGetCocktailsCount_FromFirstCategory_Returns100() {
        while cocktailsWait {}
        
        let cocktailsCount = cocktails.getNumberOfCocktails()

        XCTAssertEqual(cocktailsCount, 100)
    }
    
    func testGetCocktailName_FirstFromFirstCategory_Returns3MileLongIslandIcedTea() {
        while cocktailsWait {}
        
        let firstCocktailName = cocktails.getCocktailName(at: 0)
        
        XCTAssertEqual(firstCocktailName, "3-Mile Long Island Iced Tea")
    }
}

class CocktailsTests_ChangedCategory: XCTestCase {
    var categories: Categories!
    var cocktails: Cocktails!
    
    var categoriesWait = true
    var cocktailsWait = true
    
    let categoryIndex = 6
    
    override func setUp() {
        let restService = RestServiceMock()
        
        categories = Categories(restService: restService)
        cocktails = Cocktails(restService: restService)
        
        categories.completion = {[unowned self] in
            let categoryIndex = self.categoryIndex
            self.categoriesWait = false
            
            let categoryName = self.categories.getCategoryName(at: categoryIndex)
            self.categories.setNewCurrentCategory(index: categoryIndex)
            self.cocktails.getCocktail(from: categoryName)
        }
        
        cocktails.completion = {[unowned self] in
            self.cocktailsWait = false
        }
        
        categories.getCategories()
    }
    
    override func tearDown() {}
    
    func testIsCategoryCurrent_FirstAfterChanging_ReturnsFalse() {
        while cocktailsWait {}
        
        let isCurrent = categories.isCurrentCategory(categoryIndex: 0)
        
        XCTAssertFalse(isCurrent)
    }
    
    func testIsCategoryCurrent_SixthAfterChanging_ReturnsTrue() {
        while cocktailsWait {}
        
        let isCurrent = categories.isCurrentCategory(categoryIndex: categoryIndex)
        
        XCTAssertTrue(isCurrent)
    }
    
    func testGetCocktailsCount_FromSixthCategory_Returns100() {
        while cocktailsWait {}
        
        let cocktailsCount = cocktails.getNumberOfCocktails()
        
        XCTAssertEqual(cocktailsCount, 25)
    }
    
    func testGetCocktailName_FirstFromSixthCategory_Returns3MileLongIslandIcedTea() {
        while cocktailsWait {}
        
        let firstCocktailName = cocktails.getCocktailName(at: 0)
        
        XCTAssertEqual(firstCocktailName, "Afternoon")
    }
}
