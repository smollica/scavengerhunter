//
//  SelectionViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class SelectionViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var playHuntImageView: UIImageView!
    @IBOutlet weak var createHuntImageView: UIImageView!
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }
    
    // MARK: Actions
    
    @IBAction func playHuntTapped(sender: AnyObject) {
        performSegueWithIdentifier("playHuntSegue", sender: self)
    }
    
    @IBAction func createHuntTapped(sender: AnyObject) {
        performSegueWithIdentifier("createHuntSegue", sender: self)
    }

}