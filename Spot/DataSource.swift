//
//  DataSource.swift
//  Spot
//
//  Created by Ricky Panzer on 12/13/15.
//  Copyright © 2015 Code-Programming. All rights reserved.
//

import UIKit
import CoreData

class DataSource: NSObject {
    
    class var sharedInstance: DataSource {

        struct Singleton {
            static let instance = DataSource()
        }
        
        return Singleton.instance
    }
    
    var poi = [POI] ()
    var selectedCategory: Category?
    var managedObjectContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func reloadData() {
        if let selectedCategory = selectedCategory {
            if let poiCategories = selectedCategory.pois.allObjects as? [POI] {
                poi = poiCategories
            }
        } else {
            let fetchRequest = NSFetchRequest(entityName: "POI")
            
            do {
                if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [POI] {
                    poi = results
                }
            } catch {
                fatalError("There was an error fetching a list of POI's")
            }
        }
    }
    
    func deletePOI(index : NSInteger){
        let somePOI = poi[index]
        print("\(index)")
        managedObjectContext.deleteObject(somePOI)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving the managed object context!")
        }
        reloadData()
    }
    

}
