//
//  POI+CoreDataProperties.swift
//  Spot
//
//  Created by Nilesh Mahale on 12/12/15.
//  Copyright © 2015 Code-Programming. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension POI {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var note: String
    @NSManaged var type: Category?

}
