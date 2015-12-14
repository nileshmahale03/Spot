//
//  MapViewController.swift
//  Spot
//
//  Created by Nilesh Mahale on 11/27/15.
//  Copyright © 2015 Code-Programming. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchText: UITextField!
    
    let locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }

    //Zoom Button
    @IBAction func zoomIn(sender: AnyObject) {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 6000, 6000)
        mapView.setRegion(region, animated: true)
    }
    
    //Standard-Satellite-Hybrid Segmented Control
    @IBAction func changeMapType(sender: AnyObject) {
        if mapTypeSegmentedControl.selectedSegmentIndex == 0 {
            mapView.mapType = MKMapType.Standard
        } else if mapTypeSegmentedControl.selectedSegmentIndex == 1 {
            mapView.mapType  = MKMapType.Satellite
        } else {
            mapView.mapType = MKMapType.Hybrid
        }
    }
    
    //CLLocationManagerDelegate Methods: This will track the user's location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    //CLLocationManagerDelegate Methods:
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    //Search TextField
    @IBAction func textFieldReturn(sender: AnyObject) {
        sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()
    }
    
    //Search TextField - Cont.
    func performSearch() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler({(response: MKLocalSearchResponse?, error: NSError?) in
            if error != nil {
                print("Error occured in Search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0  {
                print("No matches found")
            } else {
                print("Matches found!!")
                
                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    print("Latitude = \(item.placemark.coordinate.latitude)")
                    print("Longitude = \(item.placemark.coordinate.longitude)")
                    
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    //Detail Button goes to "ResultTableViewController" and passes the "mapItems" Array
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! ResultTableViewController
        destination.mapItems = self.matchingItems
    }
    
    
    
}













