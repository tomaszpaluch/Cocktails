import UIKit

class MainViewController: UIViewController {
    private let logic: MainLogic
    
    private let titleLabel: UILabel
    private let categoryChooseButton: UIButton
    private let cocktailListTableView: UITableView
    
    init() {
        logic = MainLogic()
        
        titleLabel = UILabel()
        titleLabel.text = "Cocktails"
        titleLabel.font = .systemFont(ofSize: 37)
        
        categoryChooseButton = UIButton()
        categoryChooseButton.setTitle("ingredients", for: .normal)
        categoryChooseButton.titleLabel?.font = .systemFont(ofSize: 15)
        categoryChooseButton.backgroundColor = UIColor(red: 209/255, green: 0, blue: 21/255, alpha: 1)
        
        cocktailListTableView = UITableView()
        cocktailListTableView.rowHeight = 44
        
        cocktailListTableView.dataSource = logic
        cocktailListTableView.delegate = logic
        
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
        
        categoryChooseButton.addTarget(
            self,
            action: #selector(openIngredientViewController),
            for: .touchUpInside
        )
        
        logic.setupCocktailsTableView(cocktailListTableView)
        
        view.addSubview(titleLabel)
        view.addSubview(categoryChooseButton)
        view.addSubview(cocktailListTableView)
        
        setupTitleLabelConstraints()
        setupCategoryChooseButtonConstraints()
        setupCocktailListTableViewConstraints()
        
        logic.setIngredientsButtonTitle = { [weak self] title in
            DispatchQueue.main.async {
                self?.categoryChooseButton.setTitle(title, for: .normal)
            }
        }
        
        logic.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.cocktailListTableView.reloadData()
            }
        }
        
        logic.showController = { [weak self] controller in
            self?.navigationController?.pushViewController(
                controller,
                animated: true
            )
        }
        
        logic.showErrorAlert = { [weak self] alert in
            self?.present(alert, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func openIngredientViewController() {
        navigationController?.pushViewController(
            logic.makeIngredientsViewController(),
            animated: true)
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 8
        ).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupCategoryChooseButtonConstraints() {
        categoryChooseButton.translatesAutoresizingMaskIntoConstraints = false
        categoryChooseButton.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: 8
        ).isActive = true
        categoryChooseButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        categoryChooseButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        categoryChooseButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupCocktailListTableViewConstraints() {
        cocktailListTableView.translatesAutoresizingMaskIntoConstraints = false
        cocktailListTableView.topAnchor.constraint(
            equalTo: categoryChooseButton.bottomAnchor,
            constant: 8
        ).isActive = true
        cocktailListTableView.leftAnchor.constraint(
            equalTo: view.leftAnchor,
            constant: 16
        ).isActive = true
        cocktailListTableView.rightAnchor.constraint(
            equalTo: view.rightAnchor,
            constant: -16
        ).isActive = true
        cocktailListTableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -16
        ).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryChooseButton.addTarget(
            self,
            action: #selector(openIngredientViewController),
            for: .touchUpInside
        )
        
        cocktailListTableView.dataSource = logic
        cocktailListTableView.delegate = logic
    }
}
