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
    
    @IBOutlet weak var pictureImageView: SHPicture!
    @IBOutlet weak var usernameField: SHTextField!
    @IBOutlet weak var passwordField: SHTextField!
    @IBOutlet weak var emailField: SHTextField!
    @IBOutlet weak var cancelButton: SHButton!
    @IBOutlet weak var signUpButton: SHButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    
    // MARK: Properties
    
    var originalTopConstrain: CGFloat?
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.hidden = true
        
        keyboardNotificationCenter()
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
    
    // MARK: Keyboard Adjustments
    
    func keyboardNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let value = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let frame = value.CGRectValue()
        let displayOffset = self.emailField.frame.origin.y + self.emailField.frame.height + 20
        
        if displayOffset >= frame.origin.y {
            self.originalTopConstrain = self.topConstrain.constant
            self.topConstrain.constant = self.topConstrain.constant - (displayOffset - frame.origin.y)
            self.view.layoutIfNeeded()
        }

    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let constant = self.originalTopConstrain {
            self.topConstrain.constant = constant
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Alert
    
    func errorAlert(error: NSError) {
        let alertController = UIAlertController(title: "Error!", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}