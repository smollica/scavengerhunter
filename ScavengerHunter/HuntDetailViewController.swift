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
    @IBOutlet weak var huntNameLabel: SHLabel!
    @IBOutlet weak var huntCreatorLabel: SHLabel!
    @IBOutlet weak var huntPrizeLabel: SHLabel!
    @IBOutlet weak var numberOfCluesLabel: SHLabel!
    @IBOutlet weak var huntDescriptionLabel: SHLabel!
    @IBOutlet weak var startHuntButton: SHButton!
    
    // MARK: Propertu
    
    var hunt: Hunt?

    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        organizeClues()
        setFields()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style:.Plain, target:nil, action:nil)
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
        self.huntDescriptionLabel.text = "Hunt Description: " + self.hunt!.desc
        
        let huntImage = hunt!.image
        huntImage.getDataInBackgroundWithBlock({ (data, error) in
            if error == nil {
                self.huntImageView.image = UIImage(data: data!)
            }
        })

        self.huntCreatorLabel.text = "Hunt Creator: " + self.hunt!.creator!.username!
    }
    
    func organizeClues() {
        hunt?.clues.sortInPlace({ $0.number < $1.number })

    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startHunt" {
            let vc = segue.destinationViewController as! HuntViewController
            vc.hunt = self.hunt
        }
    }
    
}