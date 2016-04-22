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
    
    @IBOutlet weak var logoImageView: SHLogo!
    @IBOutlet weak var signInButton: SHButton!
    @IBOutlet weak var signUpButton: SHButton!
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        //
    }
    
    // MARK: Actions
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        if let _ = PFUser.currentUser() {
            self.performSegueWithIdentifier("signInSegue", sender: self)
        } else {
            loginAlert()
        }
    }
    
    // MARK: Alerts
    
    func loginAlert() {
        let alertController = UIAlertController(title: "Log In Please", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "username"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "password"
            textField.secureTextEntry = true
        }
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default,handler: { action in
            let usernameTextField = alertController.textFields?.first
            let passwordTextField = alertController.textFields?.last
            
            PFUser.logInWithUsernameInBackground(usernameTextField!.text!, password: passwordTextField!.text!, block: { (user, error) in
                if user != nil {
                    self.performSegueWithIdentifier("signInSegue", sender: self)
                }
            })
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Unwind Segue
    
    @IBAction func unwindHome(segue: UIStoryboardSegue) {
        //do nothing here
    }

}