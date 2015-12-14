//
//  CategoryTableViewController.swift
//  Spot
//
//  Created by Nilesh Mahale on 11/25/15.
//  Copyright © 2015 Code-Programming. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryPickerDelegate: class {
    func didSelectCategory(category: Category)
}

class CategoryTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var category = [Category]()

    // for category select mode
    weak var pickerDelegate: CategoryPickerDelegate?
    var selectedCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Category"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addCategory:")
        
        reloadData()
    }
    
    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        do {
            if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Category] {
                category = results
                tableView.reloadData()
            }
        } catch {
            fatalError("There was an error fetching a list of Categories!")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        
        let someCategory = category[indexPath.row]
        cell.textLabel?.text = someCategory.name

        if let selectedCategory = selectedCategory where selectedCategory == someCategory {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let pickerDelegate = pickerDelegate {
            let someCategory = category[indexPath.row]
            selectedCategory = someCategory
            pickerDelegate.didSelectCategory(someCategory)
            
            tableView.reloadData()
        } else {
            if let poiTableViewController = storyboard?.instantiateViewControllerWithIdentifier("POI") as? POITableViewController {
                let someCategory = category[indexPath.row]
                
                poiTableViewController.managedObjectContext = managedObjectContext
                poiTableViewController.selectedCategory = someCategory
                navigationController?.pushViewController(poiTableViewController, animated: true)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Activate delete
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return pickerDelegate == nil
    }
    
    // MARK: - Delete feature
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let someCategory = category[indexPath.row]
            managedObjectContext.deleteObject(someCategory)
            
            reloadData()
        }
    }
    
    //+ button
    func addCategory(sender: AnyObject?) {
        let alert = UIAlertController(title: "Add a Category", message: "Name?", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { (action) -> Void in
            if let textField = alert.textFields?[0],
                categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: self.managedObjectContext),
                text = textField.text where !text.isEmpty {
                    
                    let newCategory = Category(entity: categoryEntity, insertIntoManagedObjectContext: self.managedObjectContext)
                    newCategory.name = text
                    
                    self.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

}



















