//
//  ViewController.swift
//  Cocktails
//
//  Created by tomaszpaluch on 03/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var categoryChooseButton: UIButton!
    @IBOutlet private weak var cocktailListTableView: UITableView!
    
    private let restService: RestService
    private let categories: Categories
    private let cocktails: Cocktails
    
    required init?(coder aDecoder: NSCoder) {
        restService = RestService()
        categories = Categories(restService: restService)
        cocktails = Cocktails(restService: restService)
        
        super.init(coder: aDecoder)
        
        restService.errorCompletion = { [unowned self] result in
            switch result {
            case .failure(.internetConnectionError):
                self.showInternetConnectionError()
            case .failure(.serviceConnectionError):
                self.showServiceConnectionError()
            case .failure(.imageLoadingError):
                self.showImageLoadingError()
            case .success(_):
                break
            }
        }
        
        categories.completion = {[unowned self] in
            self.setCategory()
        }
        
        cocktails.completion = {[unowned self] in
            self.cocktailListRefresh()
        }
    }
    
    private func cocktailListRefresh() {
        DispatchQueue.main.async {
            self.cocktailListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cocktailListTableView.dataSource = self
        cocktailListTableView.delegate = self
        
        categories.getCategories()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktails.getNumberOfCocktails()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cocktailListTableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.textLabel?.text = cocktails.getCocktailName(at: indexPath.row)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CocktailViewController {
            let selectedRow = cocktailListTableView.indexPathForSelectedRow!.row
            let cocktailName = cocktails.getCocktailName(at: selectedRow)
            
            cocktails.getImage(ofCocktailAt: selectedRow) {
                (data: Data?) in
                destinationVC.setCocktailDetails(name: cocktailName, imageData: data)
            }
        }
        
        if let destinationVC = segue.destination as? CategoryViewController {
            destinationVC.mainViewController = self
            destinationVC.categories = categories
        }
    }
    
    func setCategory(at index: Int = 0) {
        let categoryName = categories.getCategoryName(at: index)
        categories.setNewCurrentCategory(index: index)
        
        DispatchQueue.main.async {
            self.categoryChooseButton.setTitle(categoryName, for: .normal)
        }
        
        cocktails.getCocktail(from: categoryName)
    }
    
    private func showInternetConnectionError() {
        showErrorAlert(message: "Internet connection failure")
    }
    
    private func showServiceConnectionError() {
        showErrorAlert(message: "Service connection failure")
    }
    
    private func showImageLoadingError() {
        showErrorAlert(message: "Image loading failure")
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Cocktail Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

