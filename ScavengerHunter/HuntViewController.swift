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
    @IBOutlet weak var clueLabel: SHLabel!
    @IBOutlet weak var hintLabel: SHLabel!
    @IBOutlet weak var hintButton: SHButton!
    @IBOutlet weak var nextClueButton: SHButton!
    @IBOutlet weak var quitButton: SHButton!
    
    // MARK: Properties
    
    var hunt: Hunt?
    var currentClue: Clue?
    var hotCold: Double?
    var overlays = [MKOverlay]()
    var treasureView: UIImageView?
    var treasureViewHeight: NSLayoutConstraint?
    var treasureViewWidth: NSLayoutConstraint?
    
    // MARK: LocationManager
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var lastLocation: CLLocation?
    var currentClueSolution: CLLocationCoordinate2D?
    var currentGeoFence: CLCircularRegion?
    var startingDistance: CLLocationDistance?
    var currentDistance: CLLocationDistance?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager!.requestAlwaysAuthorization()
        }
        
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        self.hintLabel.hidden = true
    }
    
    // MARK: Actions
    
    @IBAction func hintButtonPressed(sender: AnyObject) {
        makeTreasure()
        //warningAlert("Hints that are SEEN cannot be UNSEEN!", optional: true, todo: "getHint")
    }
    
    @IBAction func nextClueButtonPressed(sender: AnyObject) {
        warningAlert("Are you sure you want to go on to the NEXT CLUE (cannot be undone)?", optional: true, todo: "nextClue")
    }
    
    @IBAction func quitButtonPressed(sender: AnyObject) {
        warningAlert("Are you sure you want to QUIT the hunt (cannot be undone)?", optional: true, todo: "quitHunt")
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last

        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let currentLocation2D = CLLocationCoordinate2D(latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: currentLocation2D, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
        if self.lastLocation == nil {
            getFields()
            setupGeoFence()
        }
        
        updateColour()
        checkFoundClue()
        
        self.lastLocation = currentLocation
    }
    
//    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
//        if state == .Inside {
//            self.showGeoFence()
//            //win alert
//            nextClue()
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if region == self.currentGeoFence {
//            self.showGeoFence()
//            //win alert
//            nextClue()
//        }
//    }
    
    // MARK: GeoFencing
    
    func setupGeoFence() {
        let targetLocation2D = CLLocationCoordinate2D(latitude: (self.currentClue?.solution.latitude)!, longitude: (self.currentClue?.solution.longitude)!)
        let targetRadius = self.currentClue?.accuracy

        self.currentGeoFence = CLCircularRegion(center: targetLocation2D, radius: targetRadius!, identifier: (self.currentClue?.clue)!)
//        self.currentGeoFence!.notifyOnEntry = true
//        self.currentGeoFence!.notifyOnExit = false
        
        let targetLocation = CLLocation(latitude: (self.currentClue?.solution.latitude)!, longitude: (self.currentClue?.solution.longitude)!)
        
        self.startingDistance = (currentLocation?.distanceFromLocation(targetLocation))! - (self.currentGeoFence?.radius)!
        
        monitorForGeoFence()
    }
    
    func monitorForGeoFence() {
        self.locationManager?.startMonitoringForRegion(self.currentGeoFence!)
        self.locationManager?.requestStateForRegion(self.currentGeoFence!)
    }
    
    func delayStuff() {
        self.locationManager?.requestStateForRegion(self.currentGeoFence!)
    }
    
    // MARK: Helper Functions
    
    func getFields() {
        hunt!.clues.first?.fetchIfNeededInBackgroundWithBlock({ (object, error) in
            if error == nil {
                self.currentClue = object as? Clue
                self.currentClueSolution = CLLocationCoordinate2D(latitude: self.currentClue!.solution.latitude, longitude: self.currentClue!.solution.longitude)
                
                self.clueLabel.text = self.currentClue?.clue
                self.hintLabel.text = self.currentClue?.hint
                
                let clueImage = self.currentClue!.image
                clueImage.getDataInBackgroundWithBlock({ (data, error) in
                    if error == nil {
                        self.clueImageView.image = UIImage(data: data!)
                    }
                })
            }
        })
    }
    
    func nextClue() {
        self.hunt!.currentClue += 1
        if self.hunt!.clues.count > 0 {
            self.hunt!.clues.removeFirst()
            getFields()
            setupGeoFence()
            self.hintLabel.hidden = true
            self.overlays.removeAll()
        } else {
            // alert end of game
        }
    }
    
    func getHint() {
        if self.hintLabel.hidden {
            self.hintLabel.hidden = false
        } else {
            self.showGeoFence()
        }
    }
    
    func updateColour() {
        let targetLocation = CLLocation(latitude: (self.currentClue?.solution.latitude)!, longitude: (self.currentClue?.solution.longitude)!)
        self.currentDistance = (currentLocation?.distanceFromLocation(targetLocation))! - (self.currentGeoFence?.radius)!
        self.hotCold = self.currentDistance! / self.startingDistance!
        if self.hotCold > 1 {
            self.hotColdLabel.backgroundColor = UIColor.blueColor()
        } else if self.hotCold >= 0.5 {
            self.hotColdLabel.backgroundColor = UIColor.gradientPoint(factor: CGFloat((self.hotCold! - 0.5) * 2), color1: UIColor.yellowColor(), color2: UIColor.blueColor())
        } else {
            self.hotColdLabel.backgroundColor = UIColor.gradientPoint(factor: CGFloat(self.hotCold! * 2), color1: UIColor.redColor(), color2: UIColor.yellowColor())
        }
    }
    
    func checkFoundClue() {
        if self.hotCold <= 0 {
            // alert win
            nextClue()
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func showGeoFence() {
        self.mapView.removeOverlays(self.overlays)
        self.overlays.removeAll()
        let visualGeoFence = MKCircle(centerCoordinate: self.currentClueSolution!, radius: (self.currentClue?.accuracy)!)
        self.mapView.addOverlay(visualGeoFence)
        self.overlays.append(visualGeoFence)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.4)
        circleView.strokeColor = UIColor.redColor()
        circleView.lineWidth = 1
        return circleView
    }
    
    
    // MARK: Alert
    
    func warningAlert(string: String, optional: Bool, todo: String) {
        let alertController = UIAlertController(title: "Warning!", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        if optional {
            alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { action in
                if todo == "getHint" {
                    self.getHint()
                } else if todo == "nextClue" {
                    self.nextClue()
                } else if todo == "quitHunt" {
                    self.performSegueWithIdentifier("quitHunt", sender: self)
                }
            }))
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Image Alert
    
    func makeTreasure() {
        treasureView = UIImageView(frame: CGRectZero)
        treasureView!.image = UIImage(named: "treasure3")
        treasureView!.alpha = 0
        addTapGesture(treasureView!)
        view.addSubview(treasureView!)
        
        let centerX = NSLayoutConstraint(item: treasureView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: mapView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        view.addConstraint(centerX)
        
        let centerY = NSLayoutConstraint(item: treasureView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: mapView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        view.addConstraint(centerY)
        
        let height = NSLayoutConstraint(item: treasureView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 0)
        view.addConstraint(height)
        
        let width = NSLayoutConstraint(item: treasureView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 0)
        view.addConstraint(width)
        
        self.view.layoutIfNeeded()
        
        width.constant = self.view.frame.size.width / 1.25
        height.constant = width.constant / 1
        
        UIView.animateWithDuration(2, delay: 0, options: .CurveEaseIn, animations: {
            self.view.layoutIfNeeded()
            self.treasureView!.alpha = 1
        }) { (finished) in
            //
        }
    }
    
    func addTapGesture(imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HuntViewController.dismissTreasure))
        imageView.addGestureRecognizer(tapGesture)
    }

    func dismissTreasure() {
        treasureView!.userInteractionEnabled = false
        treasureView!.hidden = true
        treasureView!.removeFromSuperview()
    }

}