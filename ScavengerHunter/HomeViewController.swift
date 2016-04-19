//
//  HomeViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        //
    }
    
    // MARK: Actions
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("signInSegue", sender: self)
    }

}