//
//  MapViewController.swift
//  HayHay
//
//  Created by Lacie on 4/7/16.
//  Copyright © 2016 Lacie. All rights reserved.
//

import Foundation
import MapKit

import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }*/
        locationManager = CLLocationManager()
        locationManager.delegate = self

        checkLocationAuthorizationStatus();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization();
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation = User(title: nil, coordinate: locations[locations.count].coordinate, info: nil)
        mapView.addAnnotation(currLocation)
    }
    
    func locationInit() {
        locationManager.desiredAccuracy = CoreLocation.kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
}

