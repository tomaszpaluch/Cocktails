import UIKit

class IngredientsLogic: NSObject {
    var setIngredientSelected: ((String?) -> Void)?
    var reloadTableView: (() -> Void)?
    var showError: ((CocktailError) -> Void)?
    
    private let ingredients: Ingredients
    private let tableViewCellID: String
    
    init(ingredients: Ingredients) {
        self.ingredients = ingredients
        tableViewCellID = "cellID"
        
        super.init()
        
        ingredients.completion = { [weak self] result in
            switch result {
            case .success:
                self?.reloadTableView?()
            case let .failure(error):
                self?.showError?(error)
            }
        }
    }
    
    func setupIngredientsTableView(_ tableView: UITableView) {
        tableView.register(
            TableViewCell.self,
            forCellReuseIdentifier: tableViewCellID
        )
    }
}

extension IngredientsLogic: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: tableViewCellID,
            for: indexPath
        )
        
        if let cell = cell as? TableViewCell {
            cell.setup(
                ingredients.getIngredientName(at: indexPath.row),
                isCurrent: ingredients.isIngredientCurrent(at: indexPath.row)
            )
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ingredients.setNewCurrentIngredient(index: indexPath.row)
        setIngredientSelected?(ingredients.getCurrentIngredient())
    }
}
