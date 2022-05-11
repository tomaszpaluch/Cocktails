import UIKit

class IngredientsViewController: UIViewController {
    var setIngredientSelected: ((String) -> Void)?
    var showError: ((CocktailError) -> Void)? {
        get { logic.showError }
        set { logic.showError = newValue }
    }
    
    private let logic: IngredientsLogic
    
    private let ingredientsTableView: UITableView
    
    init(ingredients: Ingredients) {
        logic = IngredientsLogic(ingredients: ingredients)
        
        ingredientsTableView = UITableView()
        ingredientsTableView.rowHeight = 44

        ingredientsTableView.delegate = logic
        ingredientsTableView.dataSource = logic
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Ingredients"

        logic.setupIngredientsTableView(ingredientsTableView)

        view.addSubview(ingredientsTableView)

        setupIngredientsTableViewConstraints()
        
        logic.setIngredientSelected = { [weak self] ingredient in
            if let ingredient = ingredient {
                self?.setIngredientSelected?(ingredient)
            }
            
            self?.navigationController?.popViewController(animated: true)
        }
        
        logic.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.ingredientsTableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIngredientsTableViewConstraints() {
        ingredientsTableView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        ingredientsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        ingredientsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        ingredientsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
