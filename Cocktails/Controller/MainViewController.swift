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
    
    required init?(coder aDecoder: NSCoder) {
        restService = RestService()
        
        super.init(coder: aDecoder)
        
        restService.getCategoryCompletion = {[unowned self] in
            self.setCategory()
        }
        
        restService.getCocktailsCompletion = {[unowned self] in
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
        
        restService.getCategories()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restService.getNumberOfCocktails()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cocktailListTableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.textLabel?.text = restService.getCocktailName(at: indexPath.row)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CocktailViewController {
            let selectedRow = cocktailListTableView.indexPathForSelectedRow!.row
            let cocktailName = restService.getCocktailName(at: selectedRow)
            
            restService.getImage(ofCocktailAt: selectedRow) {
                (data:Data) in
                destinationVC.setCocktailDetails(name: cocktailName, imageData: data)
            }
        }
        
        if let destinationVC = segue.destination as? CategoryViewController {
            destinationVC.mainViewController = self
            destinationVC.restService = restService
        }
    }
    
    func setCategory(at index: Int = 0) {
        let categoryName = restService.getCategoryName(at: index)
        restService.setNewCurrentCategory(index: index)
        
        DispatchQueue.main.async {
            self.categoryChooseButton.setTitle(categoryName, for: .normal)
        }
        
        restService.getCocktails(from: categoryName)
    }
}

