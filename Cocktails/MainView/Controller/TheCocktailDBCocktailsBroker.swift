import Foundation

class TheCocktailDBCocktailsBroker {
    private let broker: RestBroker
    
    init(restService: RestService) {
        broker = RestBroker(
            restService: restService,
            siteName: "filter.php",
            urlQueryItems: [
                URLQueryItem(
                    name: "i",
                    value: "list"
                )
            ]
        )
    }
    
    func getCocktails(
        with ingredient: String,
        completion: @escaping (Result<CocktailContainer<CocktailDetails>, CocktailError>) -> Void
    ) {
        broker.getElements(
            urlQueryItems: [
                URLQueryItem(
                    name: "i",
                    value: ingredient
                )
            ],
            completion: completion
        )
    }
}
