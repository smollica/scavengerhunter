//
//  ClueCreatorViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-21.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import MapKit
import Parse

let minAccuracy: Double = 2
let defaultAccuracy: Double = 50

class ClueCreatorViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, SHImagePickerContext {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var solutionField: SHTextField!
    @IBOutlet weak var clueField: SHTextField!
    @IBOutlet weak var hintField: SHTextField!
    @IBOutlet weak var accuracyField: SHTextField!
    @IBOutlet weak var imageView: SHImage!
    @IBOutlet weak var creatClueButton: SHButton!
    @IBOutlet weak var myLocationButton: SHButton!
    
    // MARK: Properties
    
    var clueLocation: CLLocationCoordinate2D?
    var cluePFGeoPoint: PFGeoPoint?
    var clueIndex: NSIndexPath?
    var clue: Clue?
    var newHunt: Hunt?
    var newClue = true
    
    // MARK: LocationManager
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if clueIndex!.section == 1 {
            self.clue = Clue()
            self.clue!.accuracy = defaultAccuracy
            self.clue!.number = self.newHunt!.clues.count + 1
        } else {
            self.clue = newHunt!.clues[clueIndex!.row]
            self.newClue = false
        }
        
        if !self.newClue {
            self.solutionField.text = clue!.solutionText
            search()
            self.clueField.text = clue!.clue
            self.hintField.text = clue!.hint
            self.accuracyField.text = String(format: "%.0fm", clue!.accuracy)
            
            let clueImage = clue!.image
            clueImage.getDataInBackgroundWithBlock({ (data, error) in
                if error == nil {
                    self.imageView.image = UIImage(data: data!)
                }
            })
        }
        
        creatClueButton.autoLayout(view)
        self.myLocationButton.titleLabel!.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: Actions
    
    @IBAction func imageTapped(sender: AnyObject) {
        SHImagePicker.imageAlert(self)
    }
    
    @IBAction func createCluePressed(sender: AnyObject) {
        editClue()
 
        if clue!.clue == "" {
            warningAlert("Missing Clue", optional: false)
        } else if clue!.solutionText == "" || clue!.solution == PFGeoPoint() {
            warningAlert("Missing Clue Solution", optional: false)
        } else if clue!.hint == "No Hint Available" || clue!.accuracy == defaultAccuracy {
            var warning = ""
            if clue!.hint == "No Hint Available" {
                warning += "Missing Clue Hint\n"
            }
            if clue!.accuracy == defaultAccuracy {
                warning += String(format: "Clue has Default Accuracy (%.0fm)!", defaultAccuracy)
            }
            warningAlert(warning, optional: true)
        } else {
            self.createClue()
        }
    }
    
    @IBAction func myLocationPressed(sender: AnyObject) {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager!.requestAlwaysAuthorization()
        }
        
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        CLGeocoder().reverseGeocodeLocation(currentLocation!) { (placemarks, error) in
            if placemarks != nil {
                self.solutionField.text = placemarks?.first!.name
                self.clueLocation = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
                self.saveAndAnnotateSolution()
                self.locationManager!.stopUpdatingLocation()
            }
        }
        
        
        //reverse geolocation!
        
        //plot in map
    }

    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true) {}
        self.imageView.image = image
    }

    // MARK: Helper Functions
    
    func search() {
        let geo = CLGeocoder()
        geo.geocodeAddressString(self.solutionField.text!) { (placemarks, error) in
            if placemarks != nil {
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                let selection = placemarks!.first
                
                self.clueLocation = CLLocationCoordinate2D(latitude: selection!.location!.coordinate.latitude, longitude: selection!.location!.coordinate.longitude)
                
                self.saveAndAnnotateSolution()
            }
        }
    }
    
    func saveAndAnnotateSolution() {
        //var span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        
        let range = 0.002 / defaultAccuracy * (self.clue?.accuracy)!
        let span = MKCoordinateSpan(latitudeDelta: range, longitudeDelta: range)
        self.showGeoFence()
        
        let region = MKCoordinateRegion(center: self.clueLocation!, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.clueLocation!
        annotation.title = "clue solution"
        
        self.mapView.addAnnotation(annotation)
        
        self.cluePFGeoPoint = PFGeoPoint()
        self.cluePFGeoPoint!.latitude = self.clueLocation!.latitude
        self.cluePFGeoPoint!.longitude = self.clueLocation!.longitude
    }
    
    func editClue() {
        guard let clueText = clueField.text else {
            return
        }
        self.clue!.clue = clueText
        
        guard let geoPoint = self.cluePFGeoPoint else {
            return
        }
        self.clue!.solution = geoPoint
    
        self.clue!.solutionText = self.solutionField.text!
        
        if let clueImage = self.imageView.image {
            let clueImageData = UIImageJPEGRepresentation(clueImage, 0.4)
            self.clue!.image = PFFile(data: clueImageData!)!
        }
        
        if self.hintField.text != "" {
            self.clue!.hint = self.hintField.text!
        } else {
            self.clue!.hint = "No Hint Available"
        }
        
        if let accuracyString = accuracyField.text, let accuracyDouble = Double(accuracyString) {
            if accuracyDouble > minAccuracy {
                self.clue!.accuracy = accuracyDouble
            } else {
                self.clue!.accuracy = minAccuracy
            }
        } else {
            self.clue!.accuracy = defaultAccuracy
        }
        
        self.clue!.isExpanded = false
    }
    
    func createClue() {
        if self.newClue {
            self.newHunt!.clues.append(self.clue!)
        }
        performSegueWithIdentifier("unwindToClues", sender: self)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.solutionField {
            search()
        } else if textField == self.accuracyField {
            if self.clueLocation != nil {
                search()
            }
            if let accuracyString = accuracyField.text, let accuracyDouble = Double(accuracyString) {
                if accuracyDouble > minAccuracy {
                    self.clue!.accuracy = accuracyDouble
                } else {
                    self.clue!.accuracy = minAccuracy
                    self.accuracyField.text = String(format: "%.0fm", minAccuracy)
                }
            } else {
                self.clue!.accuracy = defaultAccuracy
                self.accuracyField.text = String(format: "%.0fm", defaultAccuracy)
            }
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func showGeoFence() {
        self.mapView.removeOverlays(self.mapView.overlays)
        let visualGeoFence = MKCircle(centerCoordinate: self.clueLocation!, radius: (self.clue?.accuracy)!)
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
    
    func warningAlert(string: String, optional: Bool) {
        let alertController = UIAlertController(title: "Warning!", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        if optional {
            alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { action in
                self.createClue()
            }))
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}