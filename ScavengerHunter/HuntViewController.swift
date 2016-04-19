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

class HuntViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var hotColdLabel: UILabel!
    @IBOutlet weak var clueImageView: PFImageView!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var nextClueButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        //
    }
    
    // MARK: Actions
    
    @IBAction func hintButtonPressed(sender: AnyObject) {
        //
    }
    
    @IBAction func nextClueButtonPressed(sender: AnyObject) {
        //
    }
    
    @IBAction func quitButtonPressed(sender: AnyObject) {
        //unwind to selection vc
    }
    
}