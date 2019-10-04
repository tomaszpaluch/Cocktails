//
//  CocktailViewController.swift
//  Cocktails
//
//  Created by tomaszpaluch on 03/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import UIKit

class CocktailViewController: UIViewController {
    @IBOutlet private weak var cocktailImageView: UIImageView!
    @IBOutlet private weak var cocktailNameLabel: UILabel!
    
    private var semaphore: DispatchSemaphore
    
    required init?(coder aDecoder: NSCoder) {
        semaphore = DispatchSemaphore(value: 0)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        semaphore.signal()
    }
    
    func setCocktailDetails(name: String, imageData: Data?) {
        var image: UIImage?
        
        if let imageDataUnwrapped = imageData {
            image = UIImage(data: imageDataUnwrapped)
        } 
        
        semaphore.wait()
        
        DispatchQueue.main.async {
            self.cocktailNameLabel.text = name
            self.cocktailImageView.image = image
        }
    }
    
}
