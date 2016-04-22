//
//  SHLocation.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-19.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import CoreLocation

class SHLocation: NSObject, CLLocationManagerDelegate {
    
    // MARK: Singleton
    
    static let sharedManager = SHLocation()
    
    // MARK: Properties
    
    var lat: Double = 0
    var lon: Double = 0
    
    // MARK: Private Variables
    
    private var locationManager = CLLocationManager()
    
    // MARK: Init
    
    override init() {
        super.init()
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
    }
}