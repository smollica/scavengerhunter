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
    
    // MARK: Properties
    
    var newHunt = Hunt()
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.Plain, target:nil, action:nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: Actions
    
    @IBAction func imageTapped(sender: AnyObject) {
        SHImagePicker.imageAlert(self)
    }
   
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToSelection", sender: self)
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
    
}