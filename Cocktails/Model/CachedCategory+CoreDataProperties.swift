//
//  CachedCategory+CoreDataProperties.swift
//  Cocktails
//
//  Created by tomaszpaluch on 04/10/2019.
//  Copyright © 2019 tomaszpaluch. All rights reserved.
//
//

import Foundation
import CoreData


extension CachedCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedCategory> {
        return NSFetchRequest<CachedCategory>(entityName: "CachedCategory")
    }

    @NSManaged public var name: String

}
