//
//  ViewController.swift
//  MemoryMap
//
//  Created by martin hand on 11/3/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit
import MapKit

/**
*  This View Controller displays a map. If the user changes
*  the map region (the center and the zoom level), then the
*  app persists the change
*/

class ViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return url.URLByAppendingPathComponent("mapRegionArchive").path!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreMapRegion(false)
    }
    
    // MARK: helper functions
    
    /*
    ** save the zoom level, archive dictionary into filePath
    ** place the "center" and "span" of the map into a dictionary, "span" is the width and height of the map in degrees
    */
    func saveMapRegion() {
        
        let dictionary = [
            "latitude" : mapView.region.center.latitude,
            "longitude" : mapView.region.center.longitude,
            "latitudeDelta" : mapView.region.span.latitudeDelta,
            "longitudeDelta" : mapView.region.span.longitudeDelta
        ]
        
        // archive the dictionary into the filePath
        NSKeyedArchiver.archiveRootObject(dictionary, toFile: filePath)
    }
    
    /*
    ** unarchive dictionary, use to set map back to its previous center and span
    */
    func restoreMapRegion(animated: Bool) {
        
        if let regionDictionary = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [String : AnyObject] {
            
            let longitude = regionDictionary["longitude"] as! CLLocationDegrees
            let latitude = regionDictionary["latitude"] as! CLLocationDegrees
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let longitudeDelta = regionDictionary["latitudeDelta"] as! CLLocationDegrees
            let latitudeDelta = regionDictionary["longitudeDelta"] as! CLLocationDegrees
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            
            let savedRegion = MKCoordinateRegion(center: center, span: span)
            
            print("lat: \(latitude), lon: \(longitude), latD: \(latitudeDelta), lonD: \(longitudeDelta)")
            
            mapView.setRegion(savedRegion, animated: animated)
        }
    }
    
    // MARK: map view delegate functions
    
    /*
    ** notify view controller when map region changes, save new map region
    */
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMapRegion()
    }
}

