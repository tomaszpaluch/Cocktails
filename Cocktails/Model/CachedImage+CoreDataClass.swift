//
//  CachedImage+CoreDataClass.swift
//  Cocktails
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CachedImage)
public class CachedImage: NSManagedObject {
    func setData(cocktailID: Int, imageData: Data) {
        id = cocktailID
        data = imageData
    }
}
