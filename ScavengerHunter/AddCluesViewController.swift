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

let smallCell: Double = 50
let largeCell: Double = 280
let smallTopConstraint = CGFloat(smallCell - 52)
let largeTopConstraint = CGFloat(largeCell - 52)

class AddCluesViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CreateClueTableViewCellDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var huntImageView: PFImageView!
    @IBOutlet weak var huntNameLabel: SHLabel!
    @IBOutlet weak var createHuntButton: SHButton!
    @IBOutlet weak var tableView: SHTableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var newHunt = Hunt()
    var indexClicked: NSIndexPath?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFields()
        
        self.huntNameLabel.adjustsFontSizeToFitWidth = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.Plain, target:nil, action:nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        
        self.createHuntButton.titleLabel!.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: Actions
    
    @IBAction func createHuntButtonPressed(sender: AnyObject) {
        
        var clueCountWarning = "Your Hunt has " + String(self.newHunt.clues.count) + " Clue"
        if self.newHunt.clues.count > 1 {
            clueCountWarning += "s"
        }

        if newHunt.name == "" {
            warningAlert("Missing Hunt Name", optional: false)
        } else if newHunt.prize == "" {
            warningAlert("Missing Hunt Prize", optional: false)
        } else if newHunt.clues.count == 0 {
            warningAlert("Your Hunt has Zero Clues", optional: false)
        } else if newHunt.desc == "" {
            warningAlert("Missing Hunt Description\n" + clueCountWarning, optional: true)
        } else {
            warningAlert(clueCountWarning, optional: true)
        }
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
            
            cell.editButton.setTitle("  Edit Clue  ", forState: UIControlState.Normal)
            cell.editButtonTopConstraint.constant = largeTopConstraint
                    
            cell.clueNumberLabel.hidden = false
            cell.clueImageView!.hidden = false
            cell.mapView.hidden = false
            cell.clueLabel.hidden = false
            cell.expandButton.hidden = false
            
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
                let range = 0.002 / defaultAccuracy * clue.accuracy
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
            
            cell.mapView.layer.cornerRadius = cornerRadius
            
            if clue.isExpanded {
                cell.expandButton.setImage(UIImage(named: "minus_math-25"), forState: UIControlState.Normal)
            } else {
                cell.expandButton.setImage(UIImage(named: "plus_math-25"), forState: UIControlState.Normal)
            }
            
        } else {
            cell.editButton.setTitle("  Create New Clue  ", forState: UIControlState.Normal)
            cell.editButton.tag = -1
            cell.editButtonTopConstraint.constant = smallTopConstraint
            
            cell.clueNumberLabel.hidden = true
            cell.clueImageView!.hidden = true
            cell.mapView.hidden = true
            cell.clueLabel.hidden = true
            cell.expandButton.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row > newHunt.clues.count {
                return CGFloat(largeCell)
            } else {
                if !newHunt.clues[indexPath.row].isExpanded {
                    return CGFloat(smallCell)
                } else {
                    return CGFloat(largeCell)
                }
            }
        } else {
            return CGFloat(smallCell)
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            return .Delete
        } else {
            return .None
        }
    }
    
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        let clue = newHunt.clues[indexPath.row]
        if clue.isExpanded == false {
            clue.isExpanded = true
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
 
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            newHunt.clues.removeAtIndex(indexPath.row)
            
            var renumberClue = 1
            
            for clue in newHunt.clues {
                clue.number = renumberClue
                renumberClue += 1
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            self.tableView.reloadData()
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
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
    
    
    // MARK: Helper Functions
    
    func getFields() {
        self.huntNameLabel.text = self.newHunt.name
        
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
    
    func warningAlert(string: String, optional: Bool) {
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