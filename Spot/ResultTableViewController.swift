//
//  ResultTableViewController.swift
//  Spot
//
//  Created by Nilesh Mahale on 11/27/15.
//  Copyright © 2015 Code-Programming. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ResultTableViewController: UITableViewController {
    
    var mapItems: [MKMapItem]!
    
//    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! ResultTableViewCell

        let row = indexPath.row
        let item = mapItems[row]
        cell.nameTextField?.text = item.name
        //cell.detailTextLabel?.text = item.phoneNumber

        return cell
    }
    
    //Heart Button
    @IBAction func heartPressedAction(sender: AnyObject) {

        let entityDescription = NSEntityDescription.entityForName("POI", inManagedObjectContext: DataSource.sharedInstance.managedObjectContext)
        let poi = POI(entity: entityDescription!, insertIntoManagedObjectContext: DataSource.sharedInstance.managedObjectContext)
        let point: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(point)!
        let mapItem: MKMapItem = mapItems[indexPath.row]
        
        print("Button Pressed")
        print(mapItem.name)

        poi.name = mapItem.name!
        poi.phone = mapItem.phoneNumber!
        poi.latitude = mapItem.placemark.coordinate.latitude
        poi.longitude = mapItem.placemark.coordinate.longitude
        poi.note = "Click here to edit Note"
    
        do {
            try DataSource.sharedInstance.managedObjectContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
 }






