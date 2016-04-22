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
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: SHButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var hunts = [Hunt]()
    var currentCell: Int?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className:"Hunt")
        query.findObjectsInBackgroundWithBlock({ (array, error) in
            if error == nil && array != nil {
                print("got results")
                self.hunts = array as! [Hunt]
                self.tableView.reloadData()
            } else  if array == nil {
                print("no Results")
            } else {
                print(error)
            }
        })
    }
    
    // MARK: Actions
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        //perform search
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("back", sender: self)
    }
   
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: UITableViewDataSource/Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hunts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("huntSearchCell") as! HuntSearchTableViewCell
        
        let hunt = hunts[indexPath.row]
        
        let huntImage = hunt.image
        huntImage.getDataInBackgroundWithBlock({ (data, error) in
            if error == nil {
                print("got image")
                cell.huntImageView.image = UIImage(data: data!)
            }
        })
       
        cell.huntNameLabel.text = hunt.name
        cell.numberOfCluesLabel.text = "\(hunt.clues.count)" + " Clues"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentCell = indexPath.row
        self.performSegueWithIdentifier("huntDetail", sender: self)
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "huntDetail" {
            let vc = segue.destinationViewController as! HuntDetailViewController
            vc.hunt = self.hunts[currentCell!]
        }
    }

}