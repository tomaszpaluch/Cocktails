//
//  Cache.swift
//  Cocktails
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//

import Foundation
import CoreData

class Cache {
    private var cachedCategory: [CachedCategory]
    private var cachedImageData: [CachedImage]
    private let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "Cocktails")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        context = container.viewContext
        cachedCategory = []
        cachedImageData = []
    }
    
    func fetchCategories() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedCategory")
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [CachedCategory]
            cachedCategory = fetchedObjects ?? [CachedCategory]()
        } catch {
            print(error)
        }
    }
    
    func getCategories() -> [CocktailCategory]  {
        return cachedCategory.map {$0.toCocktailCategory()}
    }
 
    func fetchImageData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedImage")
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [CachedImage]
            cachedImageData = fetchedObjects ?? [CachedImage]()
        } catch {
            print(error)
        }
    }
    
    func getImageData(cocktailID: Int) -> Data? {
        return cachedImageData.first {$0.id == cocktailID}?.data
    }
    
    func saveCategories(categories: [CocktailCategory]) {
        cachedCategory.removeAll()
        
        for category in categories {
            let object = CachedCategory(context: context)
            object.setDataFromStruct(cocktailCategory: category)
            
            cachedCategory.append(object)
        }
        
        saveContext()
    }
    
    func saveImageData(cocktailID: Int, imageData: Data) {
        if let cachedImage = cachedImageData.first(where: {$0.id == cocktailID}) {
            cachedImage.data = imageData
        } else {
            let object = CachedImage(context: context)
            object.setData(cocktailID: cocktailID, imageData: imageData)
            
            cachedImageData.append(object)
        }
        
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
