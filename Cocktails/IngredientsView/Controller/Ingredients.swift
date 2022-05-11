import Foundation

class Ingredients {
    var completion: ((Result<CocktailContainer<CocktailIndgredient>, CocktailError>) -> Void)?
    
    private let indgredientsBroker: TheCocktailDBIngredientsBroker
    private var ingredients: [CocktailIndgredient]
    
    private var currentIngredientIndex: Int?
    
    var count: Int {
        ingredients.count
    }
    
    init(restService: RestService) {
        indgredientsBroker = TheCocktailDBIngredientsBroker(
            restService: restService
        )
        
        ingredients = []
        currentIngredientIndex = nil
    }
    
    func getIngredients() {
        indgredientsBroker.getIngredients { [weak self] result in
            if case let .success(container) = result {
                self?.ingredients = container.drinks
            }

            self?.completion?(result)
        }
    }
    
    func getCurrentIngredient() -> String? {
        if let index = currentIngredientIndex {
            return ingredients[index].strIngredient1
        } else {
            return nil
        }
    }
    
    func getIngredientName(at index: Int) -> String {
        ingredients[index].strIngredient1
    }
    
    func setNewCurrentIngredient(index: Int) {
        currentIngredientIndex = index
    }
    
    func isIngredientCurrent(at index: Int) -> Bool {
        currentIngredientIndex == index
    }
}
