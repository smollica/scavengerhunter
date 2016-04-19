//
//  AddCluesViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class AddCluesViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var huntImageView: PFImageView!
    @IBOutlet weak var huntNameLabel: UILabel!
    @IBOutlet weak var createHuntButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        //
    }
    
    // MARK: Actions
    
    @IBAction func createHuntButtonPressed(sender: AnyObject) {
        //unwind segue to selection vc
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mealCell") as! CreateClueTableViewCell
    
        //cell.expandButton.addTarget(self, action: "expandCell", forControlEvents: .PrimaryActionTriggered)
        
        //let meal = meals[indexPath.row]
        
        //cell.mealImageView.image = meal.image
        //cell.mealNameLabel.text = meal.name
        //cell.mealRatingView.rating = meal.rating
        
        //return cell
        
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
    
    // MARK: TableViewCell Functions
    
    //    func expandCell(sender: UIButton) {
    //
    //
    //        let pt = self.tableView.convertPoint(sender.center, fromView: sender.superview)
    //        let indexPath = self.tableView.indexPathForRowAtPoint(pt) // may have to translate coordinates
    //    }
}