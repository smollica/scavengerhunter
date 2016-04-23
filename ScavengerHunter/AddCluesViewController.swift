//
//  AddCluesViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseUI

class AddCluesViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CreateClueTableViewCellDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var huntImageView: PFImageView!
    @IBOutlet weak var huntNameLabel: SHLabel!
    @IBOutlet weak var createHuntButton: SHButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var newHunt = Hunt()
    var indexClicked: NSIndexPath?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFields()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.Plain, target:nil, action:nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: Actions
    
    @IBAction func createHuntButtonPressed(sender: AnyObject) {
        let defaultImageData = UIImageJPEGRepresentation(UIImage(named: "empty")!, 0.4)
        let defaultFile = PFFile(data: defaultImageData!)
        
        if newHunt.name == "" {
            errorAlert("Missing Hunt Name", optional: false)
        } else if newHunt.prize == "" {
            errorAlert("Missing Hunt Prize", optional: false)
        } else if newHunt.desc == "" {
            errorAlert("Missing Hunt Descreption", optional: true)
        } else if newHunt.image == defaultFile {
            errorAlert("Missing Hunt Image", optional: true)
        } else if newHunt.clues.count == 0 {
            errorAlert("Your Hunt has Zero Clues", optional: false)
        } else {
            let string = "Your Hunt has " + String(self.newHunt.clues.count) + " Clues"
            errorAlert(string, optional: true)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: UITableViewDataSource/Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return newHunt.clues.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("createClueCell") as! CreateClueTableViewCell
        
        cell.delegate = self
        
        if indexPath.section == 0 {
            let clue = newHunt.clues[indexPath.row]
            cell.clue = clue
            cell.clueLabel.text = clue.clue
            cell.clueNumberLabel.text = "Clue # " + "\(indexPath.row + 1)"
            
            let clueImage = clue.image
            clueImage.getDataInBackgroundWithBlock({ (data, error) in
                if error == nil {
                    cell.clueImageView.image = UIImage(data: data!)
                }
            })
            
            let defaultPFGeoPoint = PFGeoPoint(latitude: 0, longitude: 0)
            
            if clue.solution != defaultPFGeoPoint {
                let range = 0.002 / 50 * clue.accuracy
                let span = MKCoordinateSpan(latitudeDelta: range, longitudeDelta: range)
                self.showGeoFence(cell)
                
                let center = CLLocationCoordinate2D(latitude: cell.clue!.solution.latitude, longitude: (cell.clue?.solution.longitude)!)
            
                let region = MKCoordinateRegion(center: center, span: span)
                
                cell.mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = "clue"
                
                cell.mapView.addAnnotation(annotation)
            }
            
            cell.editButton.tag = indexPath.row
            
            cell.expandButton.hidden = false
            
            if clue.isExpanded {
                cell.expandButton.setImage(UIImage(named: "minus_math-25"), forState: UIControlState.Normal)
            } else {
                cell.expandButton.setImage(UIImage(named: "plus_math-25"), forState: UIControlState.Normal)
            }
            
        } else {
            cell.clueNumberLabel.text = "Add Clue"
            cell.expandButton.hidden = true
            cell.editButton.tag = -1
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row > newHunt.clues.count {
                return 265
            } else {
                if !newHunt.clues[indexPath.row].isExpanded {
                    return 35
                } else {
                    return 265
                }
            }
        } else {
            return 265
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            newHunt.clues.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        }
    }
  
    // MARK CreateClueTableViewCellDelegate
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func triggerClueDetailSegue(sender: UIButton) {
        if sender.tag == -1 {
            self.indexClicked = NSIndexPath(forRow: 0, inSection: 1)
        } else {
            let row = sender.tag
            self.indexClicked = NSIndexPath(forRow: row, inSection: 0)
        }
        performSegueWithIdentifier("clueDetails", sender: self)
    }
    
    // MARK: Helper Functions
    
    func getFields() {
        self.huntNameLabel.text = "Hunt Name: " + self.newHunt.name
        
        let huntImage = newHunt.image
        huntImage.getDataInBackgroundWithBlock({ (data, error) in
            if error == nil {
                self.huntImageView.image = UIImage(data: data!)
            }
        })
        
        self.loadingIndicator.hidden = true
    }
    
    func createHunt() {
        newHunt.creator = PFUser.currentUser()
        
        self.loadingIndicator.hidden = false
        self.createHuntButton.hidden = true
        self.loadingIndicator.startAnimating()
        
        newHunt.saveInBackgroundWithBlock { (result, error) in
            self.loadingIndicator.hidden = true
            self.createHuntButton.hidden = false
            self.loadingIndicator.stopAnimating()
            self.performSegueWithIdentifier("backToSelection", sender: self)
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func showGeoFence(cell: CreateClueTableViewCell) {
        let center = CLLocationCoordinate2D(latitude: cell.clue!.solution.latitude, longitude: (cell.clue?.solution.longitude)!)
        let visualGeoFence = MKCircle(centerCoordinate: center, radius: cell.clue!.accuracy)
        cell.mapView.addOverlay(visualGeoFence)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.4)
        circleView.strokeColor = UIColor.redColor()
        circleView.lineWidth = 1
        return circleView
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clueDetails" {
            let vc = segue.destinationViewController as! ClueCreatorViewController
            vc.newHunt = self.newHunt
            vc.clueIndex = self.indexClicked
        }
    }
 
    // MARK: Unwind Segue
    
    @IBAction func unwindToClues(segue: UIStoryboardSegue) {
        //
    }
    
    // MARK: Alert
    
    func errorAlert(string: String, optional: Bool) {
        let alertController = UIAlertController(title: "Warning!", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        if optional {
            alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { action in
                self.createHunt()
            }))
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}