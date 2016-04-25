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

let defaultHolColdText = "Tap for Distance"

class HuntViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var hotColdLabel: SHHotColdLabel!
    @IBOutlet weak var clueImageView: PFImageView!
    @IBOutlet weak var clueLabel: SHLabel!
    @IBOutlet weak var hintLabel: SHLabel!
    @IBOutlet weak var hintButton: SHButton!
    @IBOutlet weak var nextClueButton: SHButton!
    @IBOutlet weak var quitButton: SHButton!
    @IBOutlet weak var hintScroll: SHScroll!
    
    // MARK: Properties
    
    var hunt: Hunt?
    var currentClue: Clue?
    var hotCold: Double?
    var treasureView: UIImageView?
    var plusButton: SHMapButton?
    var minusButton: SHMapButton?
    var playButton: SHMapButton?
    var defaultButton: SHMapButton?
    var play: Bool?
    var span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    
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
        self.hintScroll.hidden = true
        
        createButtons()
        self.play = true
        
        hintButton.autoLayout(view)
        nextClueButton.autoLayout(view)
        quitButton.autoLayout(view)
    }
    
    // MARK: Actions
    
    @IBAction func hintButtonPressed(sender: AnyObject) {
        warningAlert("Hints that are SEEN cannot be UNSEEN!", optional: true, todo: "getHint")
    }
    
    @IBAction func nextClueButtonPressed(sender: AnyObject) {
        warningAlert("Are you sure you want to go on to the NEXT CLUE (cannot be undone)?", optional: true, todo: "nextClue")
    }
    
    @IBAction func quitButtonPressed(sender: AnyObject) {
        warningAlert("Are you sure you want to QUIT the hunt (cannot be undone)?", optional: true, todo: "quitHunt")
    }
    
    @IBAction func hotColdTapped(sender: AnyObject) {
        if self.hotColdLabel.text == defaultHolColdText {
            self.hotColdLabel.text = String(format: "%.0f m", self.currentDistance!)
        } else {
            self.hotColdLabel.text = defaultHolColdText
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
        
        refreshMap()
        
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
                self.hotColdLabel.text = defaultHolColdText
                
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
        if self.hunt!.clues.count >= self.hunt!.currentClue {
            self.hunt!.clues.removeFirst()
            getFields()
            setupGeoFence()
            self.hintLabel.hidden = true
            self.hintScroll.hidden = true
            self.hotColdLabel.text = defaultHolColdText
            self.mapView.removeOverlays(self.mapView.overlays)
        } else {
            youWin()
            self.performSegueWithIdentifier("quitHunt", sender: self)
        }
    }
    
    func getHint() {
        if self.hintLabel.hidden {
            self.hintLabel.hidden = false
            self.hintScroll.hidden = false
        } else {
            self.showGeoFence()
        }
    }
    
    func updateColour() {
        let targetLocation = CLLocation(latitude: (self.currentClue?.solution.latitude)!, longitude: (self.currentClue?.solution.longitude)!)
        self.currentDistance = (currentLocation?.distanceFromLocation(targetLocation))! - (self.currentGeoFence?.radius)!
        self.hotCold = self.currentDistance! / self.startingDistance!
        if self.hotColdLabel.text != defaultHolColdText {
            self.hotColdLabel.text = String(format: "%.0f m", self.currentDistance!)
        }
        if self.hotCold > 1.00 {
            self.hotColdLabel.backgroundColor = UIColor.gradientPoint(factor: CGFloat(0.5), color1: UIColor.blueColor(), color2: UIColor.blueColor())
        } else if self.hotCold >= 0.75 {
            self.hotColdLabel.backgroundColor = UIColor.gradientPoint(factor: CGFloat((self.hotCold! - 0.75) * 4), color1: UIColor.greenColor(), color2: UIColor.blueColor())
        } else if self.hotCold >= 0.50 {
            self.hotColdLabel.backgroundColor = UIColor.gradientPoint(factor: CGFloat((self.hotCold! - 0.5) * 4), color1: UIColor.yellowColor(), color2: UIColor.greenColor())
        } else if self.hotCold >= 0.25 {
            self.hotColdLabel.backgroundColor = UIColor.gradientPoint(factor: CGFloat((self.hotCold! - 0.25) * 4), color1: UIColor.orangeColor(), color2: UIColor.yellowColor())
        } else if self.hotCold >= 0 {
            self.hotColdLabel.backgroundColor = UIColor.gradientPoint(factor: CGFloat(self.hotCold! * 4), color1: UIColor.redColor(), color2: UIColor.orangeColor())
        } else {
            self.hotColdLabel.backgroundColor = UIColor.gradientPoint(factor: CGFloat(0.5), color1: UIColor.redColor(), color2: UIColor.redColor())
        }
    }
    
    func checkFoundClue() {
        if self.currentDistance < 0 && self.clueLabel.text != "CONGRATULATIONS" {
            makeTreasure()
            self.hintLabel.text = "Clue " + String(self.currentClue!.number) + " Found!"
            self.hintLabel.hidden = false
            self.hintScroll.hidden = false
            self.clueLabel.text = "CONGRATULATIONS"
            self.hotColdLabel.hidden = true
        }
    }
    
    func refreshMap() {
        let currentLocation2D = CLLocationCoordinate2D(latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: currentLocation2D, span: self.span)
        
        if play == true {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func showGeoFence() {
        self.mapView.removeOverlays(self.mapView.overlays)
        let visualGeoFence = MKCircle(centerCoordinate: self.currentClueSolution!, radius: (self.currentClue?.accuracy)!)
        self.mapView.addOverlay(visualGeoFence)
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
        treasureView!.userInteractionEnabled = true
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
            //do nothing here
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
        nextClue()
    }
    
    func youWin() {
        // fireworks display
        self.performSegueWithIdentifier("quitHunt", sender: self)
    }
    
    // MARK: Map Controls
    
    func createButtons() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.5, constant: -20))
        
        
        minusButton = SHMapButton(frame: CGRectZero)
        minusButton!.image = UIImage(named: "minus_math-25")
        let minusTapGesture = UITapGestureRecognizer(target: self, action: #selector(HuntViewController.zoomOut))
        minusButton!.addGestureRecognizer(minusTapGesture)
        view.addSubview(minusButton!)
        minusButton!.autoLayout()
        
        view.addConstraint(NSLayoutConstraint(item: minusButton!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mapView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: buttonSpacing))
        view.addConstraint(NSLayoutConstraint(item: minusButton!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mapView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -buttonSpacing))
        
        plusButton = SHMapButton(frame: CGRectZero)
        plusButton!.image = UIImage(named: "plus_math-25")
        let plusTapGesture = UITapGestureRecognizer(target: self, action: #selector(HuntViewController.zommIn))
        plusButton!.addGestureRecognizer(plusTapGesture)
        view.addSubview(plusButton!)
        plusButton!.autoLayout()
        
        view.addConstraint(NSLayoutConstraint(item: plusButton!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: minusButton!, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: plusButton!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: minusButton!, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -buttonSpacing))
        
        playButton = SHMapButton(frame: CGRectZero)
        playButton!.image = UIImage(named: "pause_filled-25x")
        let playTapGesture = UITapGestureRecognizer(target: self, action: #selector(HuntViewController.playPause))
        playButton!.addGestureRecognizer(playTapGesture )
        view.addSubview(playButton!)
        playButton!.autoLayout()
        
        view.addConstraint(NSLayoutConstraint(item: playButton!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mapView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -buttonSpacing))
        view.addConstraint(NSLayoutConstraint(item: playButton!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: minusButton!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        defaultButton = SHMapButton(frame: CGRectZero)
        defaultButton!.image = UIImage(named: "wind_rose_filled-25x")
        let defaultTapGesture = UITapGestureRecognizer(target: self, action: #selector(HuntViewController.defaultMap))
        defaultButton!.addGestureRecognizer(defaultTapGesture)
        view.addSubview(defaultButton!)
        defaultButton!.autoLayout()
        
        view.addConstraint(NSLayoutConstraint(item: defaultButton!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: playButton, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: defaultButton!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: plusButton!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))

    }
    
    let zoomFactor = CLLocationDegrees(0.001)
    
    func zoomOut() {
        self.span.longitudeDelta +=  zoomFactor
        self.span.longitudeDelta +=  zoomFactor
        refreshMap()
    }
    
    func zommIn() {
        if self.span.longitudeDelta > zoomFactor {
            self.span.longitudeDelta -=  zoomFactor
            self.span.longitudeDelta -=  zoomFactor
        }
        refreshMap()
    }
    
    func playPause() {
        if play == true {
            playButton!.image = UIImage(named: "play_filled-25x")
            play = false
        } else {
            playButton!.image = UIImage(named: "pause_filled-25x")
            play = true
            refreshMap()
        }
    }
    
    func defaultMap() {
        self.span.longitudeDelta =  0.002
        self.span.longitudeDelta =  0.002
        play = true
        playButton!.image = UIImage(named: "pause_filled-25x")
        refreshMap()
    }

}