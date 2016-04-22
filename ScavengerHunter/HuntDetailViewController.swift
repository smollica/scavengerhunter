//
//  HuntDetailViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HuntDetailViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var huntImageView: SHImage!
    @IBOutlet weak var huntNameLabel: UILabel!
    @IBOutlet weak var huntCreatorLabel: UILabel!
    @IBOutlet weak var huntPrizeLabel: UILabel!
    @IBOutlet weak var numberOfCluesLabel: UILabel!
    @IBOutlet weak var huntDescriptionLabel: UILabel!
    @IBOutlet weak var startHuntButton: SHButton!
    
    // MARK: Propertu
    
    var hunt: Hunt?

    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        setFields()
    }
    
    // MARK: Actions
    
    @IBAction func startHuntButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("startHunt", sender: self)
    }
    
    // MARK: Helper Functions
    
    func setFields() {
        self.huntNameLabel.text = "Hunt Name: " + self.hunt!.name
        self.huntPrizeLabel.text = "Hunt Prize: " + self.hunt!.prize
        self.numberOfCluesLabel.text = "Hunt Size: " + "\(self.hunt!.clues.count)" + " Clues"
        self.huntDescriptionLabel.text = "hunt Description: " + self.hunt!.desc
        
        let huntImage = hunt!.image
        huntImage.getDataInBackgroundWithBlock({ (data, error) in
            if error == nil {
                print("got image")
                self.huntImageView.image = UIImage(data: data!)
            }
        })
        
        do {
            try self.hunt!.creator!.fetchIfNeeded()
            self.huntCreatorLabel.text = "Hunt Creator: " + self.hunt!.creator!.username!
        } catch _ {
            print("There was an error")
        }
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startHunt" {
            let vc = segue.destinationViewController as! HuntViewController
            vc.hunt = self.hunt
        }
    }
    
}