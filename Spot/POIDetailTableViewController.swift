//
//  POIDetailTableViewController.swift
//  Spot
//
//  Created by Nilesh Mahale on 11/25/15.
//  Copyright © 2015 Code-Programming. All rights reserved.
//

import UIKit
import CoreData

class POIDetailTableViewController: UITableViewController {
    
//    var managedObjectContext: NSManagedObjectContext!
    var poi: POI?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let somePOI = poi {
            nameTextField.text = somePOI.name
            phoneTextField.text = somePOI.phone
            noteTextField.text = somePOI.note

            if let type = poi?.type {
                categoryLabel.text = "Category type: \(type.name)"
            } else {
                categoryLabel.text = "Set Category type"
            }

        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let poi = poi, name = nameTextField.text, phone = phoneTextField.text, note = noteTextField.text {
            poi.name = name
            poi.phone = phone
            poi.note = note
        } else if poi == nil {
            if let name = nameTextField.text, phone = phoneTextField.text, note = noteTextField.text, entity = NSEntityDescription.entityForName("POI", inManagedObjectContext: DataSource.sharedInstance.managedObjectContext) where !name.isEmpty && !phone.isEmpty && !note.isEmpty {
                poi = POI(entity: entity, insertIntoManagedObjectContext: DataSource.sharedInstance.managedObjectContext)
                poi?.name = name
                poi?.phone = phone
                poi?.note = note
            }
        }
        
        do {
            try DataSource.sharedInstance.managedObjectContext.save()
        } catch {
            print("Error saving the managed object context!")
        }
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            if let categoryPicker = storyboard?.instantiateViewControllerWithIdentifier("Category") as? CategoryTableViewController {
//                categoryPicker.managedObjectContext = DataSource.sharedInstance.managedObjectContext
                
                categoryPicker.pickerDelegate = self
                categoryPicker.selectedCategory = poi?.type
                
                navigationController?.pushViewController(categoryPicker, animated: true)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

extension POIDetailTableViewController: CategoryPickerDelegate {
    func didSelectCategory(category: Category) {
        poi?.type = category
        
        do {
            try DataSource.sharedInstance.managedObjectContext.save()
        } catch {
            print("Error saving the managed object context!")
        }
    }
}




















