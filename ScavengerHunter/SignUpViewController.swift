//
//  SignUpViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, SHImagePickerContext {
    
    // MARK: Outlets
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var cancelButton: SHButton!
    @IBOutlet weak var signUpButton: SHButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator.hidden = true
    }
    
    // MARK: Actions
    
    @IBAction func pictureTapped(sender: AnyObject) {
        SHImagePicker.imageAlert(self)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindHome", sender: self)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        self.cancelButton.hidden = true
        self.signUpButton.hidden = true
        self.loadingIndicator.hidden = false
        self.loadingIndicator.startAnimating()
        
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.email = emailField.text
        
        user.signUpInBackgroundWithBlock { (result, error) in
            if result {
                self.performSegueWithIdentifier("signUpSegue", sender: self)
            } else if error != nil {
                self.errorAlert(error!)
            }
            self.cancelButton.hidden = false
            self.signUpButton.hidden = false
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true) {}
        self.pictureImageView.image = image
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: Alert
    
    func errorAlert(error: NSError) {
        let alertController = UIAlertController(title: "Error!", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}