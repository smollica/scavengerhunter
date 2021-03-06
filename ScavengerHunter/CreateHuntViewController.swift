//
//  CreateHuntViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class CreateHuntViewController: UIViewController, UITextFieldDelegate, SHImagePickerContext {
    
    // MARK: Outlets
    
    @IBOutlet weak var huntImageView: SHImage!
    @IBOutlet weak var nameField: SHTextField!
    @IBOutlet weak var prizeField: SHTextField!
    @IBOutlet weak var descriptionField: SHTextField!
    @IBOutlet weak var addCluesButton: SHButton!
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    
    // MARK: Properties
    
    var newHunt = Hunt()
    var originalTopConstrain: CGFloat?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.Plain, target:nil, action:nil)
        
        keyboardNotificationCenter()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: Actions
    
    @IBAction func imageTapped(sender: AnyObject) {
        SHImagePicker.imageAlert(self)
    }
   
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.warningAlert("Your current HUNT will be LOST by clicking Back!", optional: true)
    }
    
    @IBAction func getFields() {
        if nameField.text != nil {
            self.newHunt.name = nameField.text!
        }
        
        if prizeField.text != nil {
            self.newHunt.prize = prizeField.text!
        }
        
        if descriptionField.text != nil {
            self.newHunt.desc = descriptionField.text!
        }
        
        if let huntImage = self.huntImageView.image {
            let huntImageData = UIImageJPEGRepresentation(huntImage, 0.4)
            newHunt.image = PFFile(data: huntImageData!)!
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true) {}
        self.huntImageView.image = image
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addCluesSegue" {
            let vc = segue.destinationViewController as! AddCluesViewController
            vc.newHunt = self.newHunt
        }
    }
    
    // MARK: Keyboard Adjustments
    
    func keyboardNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let value = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let frame = value.CGRectValue()
        let displayOffset = self.descriptionField.frame.origin.y + self.descriptionField.frame.height + 20
        
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
    
    func warningAlert(string: String, optional: Bool) {
        let alertController = UIAlertController(title: "Warning!", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        if optional {
            alertController.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { action in
                self.performSegueWithIdentifier("unwindToSelection", sender: self)
            }))
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}