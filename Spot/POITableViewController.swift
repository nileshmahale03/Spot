//
//  POITableViewController.swift
//  Spot
//
//  Created by Nilesh Mahale on 11/25/15.
//  Copyright © 2015 Code-Programming. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import Social

class POITableViewController: UITableViewController {
    


    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = "POI"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPOI:")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        DataSource.sharedInstance.reloadData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    
        
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.sharedInstance.poi.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> POITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("POICell", forIndexPath: indexPath) as! POITableViewCell
        
        let somePOI = DataSource.sharedInstance.poi[indexPath.row]
        
        cell.nameLabel.text = somePOI.name
        cell.phoneLabel.text = somePOI.phone
        cell.notesLabel.text = somePOI.note
        
        return cell
    }
    
    // MARK: - Activate delete
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: - Delete feature
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            DataSource.sharedInstance.deletePOI(indexPath.row)
            tableView.reloadData()
        }
    }
    
    // MARK: - Delete & Share feature
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: {(action: UITableViewRowAction, indexPath:NSIndexPath) -> Void in
        
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            
                guard SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
                    else {
                        let alertMessage = UIAlertController(title: "Twitter Unavailable", message: "You haven't registered your Twitter account. Please go to Settings > Twitter to create one.", preferredStyle: .Alert)
                        alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alertMessage, animated: true, completion: nil)
                        
                        return
                }
                
                let somePOI = DataSource.sharedInstance.poi[indexPath.row]
                let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                tweetComposer.setInitialText(somePOI.name)
                
                self.presentViewController(tweetComposer, animated: true, completion: nil)
                
            })
            
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            
                guard SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
                    else {
                        let alertMessage = UIAlertController(title: "Facebook Unavailable", message: "You haven't registered your Facebook account. Please go to Settings > Facebook to create one.", preferredStyle: .Alert)
                        alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alertMessage, animated: true, completion: nil)
                        
                        return
                }
                
                let somePOI = DataSource.sharedInstance.poi[indexPath.row]
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposer.setInitialText(somePOI.name)
                
                self.presentViewController(facebookComposer, animated: true, completion: nil)
            
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(cancelAction)
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })

        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {(action: UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
            DataSource.sharedInstance.deletePOI(indexPath.row)
            
            tableView.reloadData()
        })
        
        shareAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    // MARK: - Actions & Segues
    
    //+ Button
    func addPOI(sender: AnyObject?) {
        performSegueWithIdentifier("poiDetail", sender: self)
    }
    
    //1. POIDetail 2. RouteView
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? POIDetailTableViewController {
//            dest.managedObjectContext = managedObjectContext
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let somePOI = DataSource.sharedInstance.poi[selectedIndexPath.row]
                dest.poi = somePOI
            }
        } else if let dest = segue.destinationViewController as? RouteViewController {
            let indexPath: NSIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
            let somePOI : POI = DataSource.sharedInstance.poi[indexPath.row]
            let mapItem: MKMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: somePOI.latitude.doubleValue, longitude: somePOI.longitude.doubleValue), addressDictionary: nil))
            
            print(somePOI.name)
            
            dest.destination = mapItem
        }

    }
}
















