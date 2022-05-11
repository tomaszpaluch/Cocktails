import XCTest
@testable import Cocktails

class IngredientsTests: XCTestCase {
    var ingredients: Ingredients!

    var currentIngredientIndex: Int!
    
    override func setUp() {
        let restService = RestServiceMock(of: .ingredients, with: .success)
        ingredients = Ingredients(restService: restService)
        currentIngredientIndex = 21
        
        ingredients.getIngredients()
        ingredients.setNewCurrentIngredient(index: currentIngredientIndex)
    }

    override func tearDown() {}
    
    func testGetIngredientsCount_Standard_Returns100() {
        XCTAssertEqual(ingredients.count, 100)
    }
    
    func testGetIngredientName_First_ReturnsLightRum() {
        let firstIngredient = ingredients.getIngredientName(at: 0)
        
        XCTAssertEqual(firstIngredient, "Light rum")
    }

    func testIsIngredientCurrent_21th_ReturnsTrue() {
        let isCurrent = ingredients.isIngredientCurrent(at: currentIngredientIndex)

        XCTAssertTrue(isCurrent)
    }

    func testIsCategoryCurrent_SixthAtTheBegining_ReturnsFalse() {
        let isCurrent = ingredients.isIngredientCurrent(at: 6)

        XCTAssertFalse(isCurrent)
    }
}
