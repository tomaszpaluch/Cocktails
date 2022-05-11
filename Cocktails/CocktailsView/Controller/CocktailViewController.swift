import UIKit

class CocktailViewController: UIViewController {
    private var cocktailImageView: UIImageView
    
    private let logic: CocktailLogic

    init(cocktailDetails: CocktailDetails) {
        logic = CocktailLogic()
        
        cocktailImageView = UIImageView()
        cocktailImageView.contentMode = .scaleAspectFill
        cocktailImageView.backgroundColor = .lightGray
                
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = cocktailDetails.strDrink
        view.backgroundColor = .white
        
        view.addSubview(cocktailImageView)
        
        setupCocktailImageViewConstraints()
        
        logic.getImage(imagePath: cocktailDetails.strDrinkThumb) { [weak self] image in
            DispatchQueue.main.async {
                self?.cocktailImageView.image = image
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCocktailImageViewConstraints() {
        cocktailImageView.translatesAutoresizingMaskIntoConstraints = false
        cocktailImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cocktailImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cocktailImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cocktailImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
