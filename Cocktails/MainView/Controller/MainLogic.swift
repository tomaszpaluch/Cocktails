import UIKit

class MainLogic: NSObject {
    var setIngredientsButtonTitle: ((String) -> Void)?
    var reloadTableView: (() -> Void)?
    var showController: ((UIViewController) -> Void)?
    var showErrorAlert: ((UIAlertController) -> Void)?
    
    private let ingredients: Ingredients
    private let cocktails: Cocktails
    private let thumbnailData: ThumbnailData
    
    private let tableViewCellID: String
    
    override init() {
        let restService = RestService()
        ingredients = Ingredients(restService: restService)
        cocktails = Cocktails(restService: restService)
        thumbnailData = ThumbnailData()
        
        tableViewCellID = "cellID"
        
        super.init()
        
        ingredients.completion = { [weak self] result in
            if case let .failure(error) = result {
                self?.showError(for: error)
            }
        }
        
        ingredients.getIngredients()
    }
    
    func setupCocktailsTableView(_ tableView: UITableView) {
        tableView.register(
            CocktailTableViewCell.self,
            forCellReuseIdentifier: tableViewCellID
        )
    }
    
    func makeIngredientsViewController() -> UIViewController {
        let controller = IngredientsViewController(ingredients: ingredients)
        
        controller.setIngredientSelected = { [weak self] ingredient in
            self?.setIngredientsButtonTitle?(ingredient)
            
            self?.cocktails.getCocktails(with: ingredient) { result in
                switch result {
                case .success:
                    self?.reloadTableView?()
                case let .failure(error):
                    self?.showError(for: error)
                }
                
            }
        }
    
        controller.showError = { [weak self] error in
            self?.showError(for: error)
        }
        
        return controller
    }
    
    private func showError(for error: CocktailError) {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.showErrorAlert?(
                    self.makeErrorAlert(
                        error: error
                    )
                )
            }
        }
    }
    
    private func makeErrorAlert(error: CocktailError) -> UIAlertController {
        switch error {
        case .internetConnectionError:
            return makeErrorAlert(message: "Internet connection failure")
        case .serviceConnectionError:
            return makeErrorAlert(message: "Service connection failure")
        case .imageLoadingError:
            return makeErrorAlert(message: "Image loading failure")
        }
    }
    
    private func makeErrorAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Cocktail Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
}

extension MainLogic: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath)
        
        if let cell = cell as? CocktailTableViewCell {
            let cocktail = cocktails.getCocktailDetails(at: indexPath.row)
            
            let thumbnail = thumbnailData.getCocktailThumbnail(for: cocktail) {
                DispatchQueue.main.async {
                    tableView.reloadRows(
                        at: [IndexPath(
                            row: indexPath.row,
                            section: indexPath.section
                            )
                        ],
                        with: .none
                    )
                }
            }
            
            cell.setup(cocktail.strDrink, image: thumbnail)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cocktail = cocktails.getCocktailDetails(at: indexPath.row)
        let controller = CocktailViewController(cocktailDetails: cocktail)
        showController?(controller)
    }
}

