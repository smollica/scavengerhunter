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

class ClueCreatorViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, SHImagePickerContext {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var solutionField: UITextField!
    @IBOutlet weak var clueField: UITextField!
    @IBOutlet weak var hintField: UITextField!
    @IBOutlet weak var accuracyField: UITextField!
    @IBOutlet weak var imageView: SHImage!
    
    // MARK: Properties
    
    var clueLocation: CLLocationCoordinate2D?
    var cluePFGeoPoint: PFGeoPoint?
    var clueIndex: NSIndexPath?
    var clue: Clue?
    var newHunt: Hunt?
    var newClue = true
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if clueIndex!.section == 1 {
            self.clue = Clue()
            self.clue!.accuracy = 50
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
            self.accuracyField.text = String(clue!.accuracy)
            
            let clueImage = clue!.image
            clueImage.getDataInBackgroundWithBlock({ (data, error) in
                if error == nil {
                    print("got image")
                    self.imageView.image = UIImage(data: data!)
                } else {
                    print("error")
                }
            })
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func imageTapped(sender: AnyObject) {
        SHImagePicker.imageAlert(self)
    }
    
    @IBAction func createCluePressed(sender: AnyObject) {
        editClue()
        if self.newClue {
            self.newHunt!.clues.append(self.clue!)
        }
        performSegueWithIdentifier("unwindToClues", sender: self)
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
                let selection = placemarks!.first
                
                self.clueLocation = CLLocationCoordinate2D(latitude: selection!.location!.coordinate.latitude, longitude: selection!.location!.coordinate.longitude)
                
                //var span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
               
                let range = 0.002 / 50 * (self.clue?.accuracy)!
                let span = MKCoordinateSpan(latitudeDelta: range, longitudeDelta: range)
                self.showGeoFence()
    
                let region = MKCoordinateRegion(center: self.clueLocation!, span: span)
                
                self.mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.clueLocation!
                annotation.title = "clue"
                
                self.mapView.addAnnotation(annotation)
                
                self.cluePFGeoPoint = PFGeoPoint()
                self.cluePFGeoPoint!.latitude = self.clueLocation!.latitude
                self.cluePFGeoPoint!.longitude = self.clueLocation!.longitude
                
            } else if error != nil {
                print(error)
            }
        }
    }
    
    func editClue() {
        
        //create protection for creating incomplete clues
        
        guard let clueText = clueField.text else {
            //add alert
            return
        }
        self.clue!.clue = clueText
        
        guard let geoPoint = self.cluePFGeoPoint else {
            //add alert
            return
        }
        self.clue!.solution = geoPoint
    
        self.clue!.solutionText = self.solutionField.text!
        
        if let clueImage = self.imageView.image {
            let clueImageData = UIImageJPEGRepresentation(clueImage, 0.4)
            self.clue!.image = PFFile(data: clueImageData!)!
        }
        
        if let clueHint = hintField.text {
            self.clue!.hint = clueHint
        }
        
        if let accuracyString = accuracyField.text, let accuracyDouble = Double(accuracyString) {
            if accuracyDouble > 50 {
                self.clue!.accuracy = accuracyDouble
            } else {
                self.clue!.accuracy = 50
            }
        } else {
            self.clue!.accuracy = 50
        }
        
        self.clue!.isExpanded = false
        
    }
    
    func showGeoFence() {
        let visualGeoFence = MKCircle(centerCoordinate: self.clueLocation!, radius: (self.clue?.accuracy)!)
        self.mapView.addOverlay(visualGeoFence)
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
                if accuracyDouble > 50 {
                    self.clue!.accuracy = accuracyDouble
                } else {
                    self.clue!.accuracy = 50
                }
            } else {
                self.clue!.accuracy = 50
            }
        }
    }
    
}