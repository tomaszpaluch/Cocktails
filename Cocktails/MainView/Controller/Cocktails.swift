import Foundation

class Cocktails {
    private let cocktailsBroker: TheCocktailDBCocktailsBroker
    private var cocktails: [CocktailDetails]
    
    var count: Int {
        cocktails.count
    }
    
    init(restService: RestService) {
        cocktailsBroker = TheCocktailDBCocktailsBroker(
            restService: restService
        )
        
        cocktails = []
    }
    
    func getCocktails(
        with ingredient: String,
        completion: @escaping (Result<CocktailContainer<CocktailDetails>, CocktailError>) -> Void
    ) {
        cocktailsBroker.getCocktails(with: ingredient) { [weak self] result in
            if case let .success(container) = result {
                self?.cocktails = container.drinks
            }
            
            completion(result)
        }
    }

    func getCocktailDetails(at index: Int) -> CocktailDetails {
        cocktails[index]
    }
}
