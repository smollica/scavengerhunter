//
//  HuntViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseUI

class HuntViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var hotColdLabel: UILabel!
    @IBOutlet weak var clueImageView: PFImageView!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hintButton: SHButton!
    @IBOutlet weak var nextClueButton: SHButton!
    @IBOutlet weak var quitButton: SHButton!
    
    // MARK: Properties
    
    var hunt: Hunt?
    var currentClue: Clue?
    var hotCold: Double?
    
    // MARK: LocationManager
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var lastLocation: CLLocation?
    var currentGeoFence: CLCircularRegion?
    var startingDistance: CLLocationDistance?
    var currentDistance: CLLocationDistance?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentClue = Clue()//
        currentClue!.solution = PFGeoPoint(latitude: 49.2769, longitude: -122.9148)//
        currentClue!.accuracy = 7000//
        
        getFields()
       
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager!.requestWhenInUseAuthorization()
        }
        
        setupGeoFence()
        
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        self.hintLabel.hidden = true
    }
    
    // MARK: Actions
    
    @IBAction func hintButtonPressed(sender: AnyObject) {
        self.clueLabel.text = String(self.currentDistance)//
        setupGeoFence()//
//        getHint()
    }
    
    @IBAction func nextClueButtonPressed(sender: AnyObject) {
        // alert
        nextClue()
    }
    
    @IBAction func quitButtonPressed(sender: AnyObject) {
        // alert
        self.performSegueWithIdentifier("quitHunt", sender: self)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
        
//        if self.lastLocation == nil {
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let currentLocation2D = CLLocationCoordinate2D(latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: currentLocation2D, span: span)
            
            self.mapView.setRegion(region, animated: true)
//        }
//        
//        self.lastLocation = currentLocation
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == .Inside && region == self.currentGeoFence {
            //win alert
//            nextClue()
            print("hit on determine")
            self.clueLabel.text = String("hit on determine")
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region == self.currentGeoFence {
            //win alert
            //            nextClue()
            print("hit on enter")
            self.clueLabel.text = String("hit on enter")
        }
    }
    
    // MARK: GeoFencing
    
    func setupGeoFence() {
        let targetLocation2D = CLLocationCoordinate2D(latitude: (self.currentClue?.solution.latitude)!, longitude: (self.currentClue?.solution.latitude)!)
        let targetRadius = self.currentClue?.accuracy
        
        self.currentGeoFence = CLCircularRegion(center: targetLocation2D, radius: targetRadius!, identifier: "")
        self.currentGeoFence!.notifyOnEntry = true
        self.currentGeoFence!.notifyOnExit = false
        
        let targetLocation = CLLocation(latitude: (self.currentClue?.solution.latitude)!, longitude: (self.currentClue?.solution.latitude)!)
        
        self.currentDistance = currentLocation?.distanceFromLocation(targetLocation)
        
        monitorForGeoFence()
    }
    
    func monitorForGeoFence() {
        self.locationManager?.startMonitoringForRegion(self.currentGeoFence!)
    }
    
    // MARK: Helper Functions
    
    func getFields() {
//        self.currentClue = hunt!.clues.first
        self.clueLabel.text = self.currentClue?.clue
        self.hintLabel.text = self.currentClue?.hint
    }
    
    func getHint() {
        self.hintLabel.hidden = false
    }
    
    func nextClue() {
        self.hunt!.currentClue += 1
        if self.hunt!.clues.count > 0 {
            self.hunt!.clues.removeFirst()
            getFields()
            setupGeoFence()
        } else {
            // alert end of game
        }
    }
    
    // MARK: Alerts
    
}

// MARK: UIColor Extension

extension UIColor {
    class func gradientPoint(factor factor:CGFloat, color1:UIColor, color2:UIColor) -> UIColor
    {
        let c1 = color1.getComponents()
        let c2 = color2.getComponents()
        
        let newR = c1.red + (factor*(c2.red-c1.red))
        let newG = c1.green + (factor*(c2.green-c1.green))
        let newB = c1.blue + (factor*(c2.blue-c1.blue))
        
        return UIColor.init(red: newR, green: newG, blue: newB, alpha: 1.0)
    }
    
    func getComponents() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)
    {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }

}