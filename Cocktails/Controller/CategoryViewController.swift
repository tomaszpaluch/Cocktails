//
//  CategoryViewController.swift
//  Cocktails
//
//  Created by tomaszpaluch on 03/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var categoriesTableView: UITableView!
    
    public var categories: Categories!
    public var mainViewController: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.getNumberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCellID", for: indexPath) as! TableViewCell
        
        cell.categoryNameLabel.text = categories.getCategoryName(at: indexPath.row)
        cell.checkLabel.isHidden = !categories.isCurrentCategory(categoryIndex: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainViewController.setCategory(at: indexPath.row)
        navigationController?.popToRootViewController(animated: true)
    }
}
