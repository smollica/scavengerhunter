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
    @IBOutlet weak var signInButton: SHLargeButton!
    @IBOutlet weak var signUpButton: SHLargeButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingIndicator.hidden = true
        signInButton.autoLayout(view)
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
        let alertController = UIAlertController(title: "Log In Please", message:"", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "username"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "password"
            textField.secureTextEntry = true
        }
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default, handler: { action in
            let usernameTextField = alertController.textFields?.first
            let passwordTextField = alertController.textFields?.last
            self.signInButton.hidden = true
            self.signUpButton.hidden = true
            self.loadingIndicator.hidden = false
            self.loadingIndicator.startAnimating()
            
            PFUser.logInWithUsernameInBackground(usernameTextField!.text!, password: passwordTextField!.text!, block: { (user, error) in
                if user != nil {
                    self.signInButton.hidden = false
                    self.signUpButton.hidden = false
                    self.loadingIndicator.hidden = true
                    self.loadingIndicator.stopAnimating()
                    self.performSegueWithIdentifier("signInSegue", sender: self)
                }  else if error != nil {
                    self.errorAlert(error!)
                }
            })
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Unwind Segue
    
    @IBAction func unwindHome(segue: UIStoryboardSegue) {
        //do nothing here
    }    
    
    // MARK: Alert
    
    func errorAlert(error: NSError) {
        let alertController = UIAlertController(title: "Error!", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}