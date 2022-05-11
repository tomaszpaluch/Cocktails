import Foundation

class TheCocktailDBIngredientsBroker {
    private let broker: RestBroker
    
    init(restService: RestService) {
        broker = RestBroker(
            restService: restService,
            siteName: "list.php",
            urlQueryItems: [
                URLQueryItem(
                    name: "i",
                    value: "list"
                )
            ]
        )
    }
    
    func getIngredients(
        completion: @escaping (Result<CocktailContainer<CocktailIndgredient>, CocktailError>) -> Void
    ) {
        broker.getElements(completion: completion)
    }
}
