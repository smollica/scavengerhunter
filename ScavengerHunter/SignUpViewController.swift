//
//  SignUpViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
    }
    
    // MARK: Actions
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        //unwind to home vc
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("signUpSegue", sender: self)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

}