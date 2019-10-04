//
//  CachedCategory+CoreDataClass.swift
//  Cocktails
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CachedCategory)
public class CachedCategory: NSManagedObject {

    func toCocktailCategory() -> CocktailCategory {
        return CocktailCategory(strCategory: name, isCurrent: nil)
    }
    
    func setDataFromStruct(cocktailCategory: CocktailCategory) {
        name = cocktailCategory.strCategory
    }
}
