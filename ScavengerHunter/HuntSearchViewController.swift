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
    @IBOutlet weak var searchField: SHTextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: SHTableView!
    
    // MARK: Properties
    
    var hunts = [Hunt]()
    var displayHunts = [Hunt]()
    var currentCell: Int?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className:"Hunt")
        query.includeKey("clues")
        query.includeKey("creator")
        query.findObjectsInBackgroundWithBlock({ (array, error) in
            if error == nil && array != nil {
                self.hunts = array as! [Hunt]
                
                for hunt in self.hunts {
                    self.displayHunts.append(hunt)
                }

                self.tableView.reloadData()
            }
        })
        
        fixButton()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.Plain, target:nil, action:nil)
    }
    
    // MARK: Actions
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        performSearch()
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("back", sender: self)
    }
    
    // MARK: UITableViewDataSource/Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayHunts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("huntSearchCell") as! HuntSearchTableViewCell
        
        let hunt = displayHunts[indexPath.row]
        
        let huntImage = hunt.image
        huntImage.getDataInBackgroundWithBlock({ (data, error) in
            if error == nil {
                cell.huntImageView.image = UIImage(data: data!)
            }
        })
       
        cell.huntNameLabel.text = hunt.name
        
        var clueCountLabel = "\(hunt.clues.count)" + " Clue"
        if hunt.clues.count > 1 {
            clueCountLabel += "s"
        }
        
        cell.numberOfCluesLabel.text = clueCountLabel
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentCell = indexPath.row
        self.performSegueWithIdentifier("huntDetail", sender: self)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: Helper Functions
    
    func performSearch() {
        displayHunts.removeAll()
        if let searchString = self.searchField.text {
            for hunt in hunts {
                if hunt.creator!.username!.containsString(searchString) || hunt.name.containsString(searchString) || hunt.prize.containsString(searchString) || hunt.desc.containsString(searchString) || hunt.clues.count == Int(searchString) || self.searchField.text == "" {
                    displayHunts.append(hunt)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func fixButton() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.backgroundColor = UIColor.myColour1()
        searchButton.tintColor = UIColor.myColour2()
        searchButton.layer.borderColor = UIColor.myColour4().CGColor
        searchButton.layer.borderWidth = borderWidth
        searchButton.layer.cornerRadius = cornerRadius
        searchButton.layer.shadowColor = UIColor.myColour3().CGColor
        searchButton.layer.shadowOffset = shadowOffset
        searchButton.layer.shadowOpacity = shadowOpacity
        searchButton.titleLabel!.font = UIFont(name: buttonFont, size: 16)
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "huntDetail" {
            let vc = segue.destinationViewController as! HuntDetailViewController
            vc.hunt = self.displayHunts[currentCell!]
        }
    }

}