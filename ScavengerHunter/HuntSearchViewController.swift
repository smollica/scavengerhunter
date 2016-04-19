//
//  HuntSearchViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class HuntSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var hunts = [Hunt]()
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        //
    }
    
    // MARK: Actions
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        //perform search
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hunts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mealCell") as! HuntSearchTableViewCell
        
        let hunt = hunts[indexPath.row]
        
        cell.huntImageView.image = hunt.image
        cell.huntNameLabel.text = hunt.name
        cell.numberOfCluesLabel.text = "\(hunt.clues.count)" + " Clues"
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //meals.removeAtIndex(indexPath.row)
            //saveMeals()
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        }
    }

}