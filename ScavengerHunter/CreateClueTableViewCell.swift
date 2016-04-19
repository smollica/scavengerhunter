//
//  CreateClueTableViewCell.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import MapKit
import Parse

class CreateClueTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var clueNumberLabel: UILabel!
    @IBOutlet weak var clueImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var clueField: UITextField!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var hintField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var createClueButton: UIButton!
    
    
    // MARK: Actions
    
    @IBAction func expandButtonPressed(sender: AnyObject) {
        //
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        //
    }
    
    @IBAction func createClueButtonPressed(sender: AnyObject) {
        //
    }
    
}