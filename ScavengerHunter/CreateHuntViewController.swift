//
//  CreateHuntViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class CreateHuntViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var createHuntLabel: UILabel!
    @IBOutlet weak var huntImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var accuracyField: UITextField!
    @IBOutlet weak var prizeField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addCluesButton: UIButton!
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        //
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @IBAction func addCluesButtonPressed(sender: AnyObject) {
        self.tabBarController!.selectedIndex = 1
    }

}