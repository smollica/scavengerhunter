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
        self.huntNameLabel.text = self.hunt!.name
        self.huntCreatorLabel.attributedText = labelMaker("Hunt Creator: ", labelDescriptor: self.hunt!.creator!.username!)
        self.huntPrizeLabel.attributedText = labelMaker("Hunt Prize: ", labelDescriptor: self.hunt!.prize)
        self.numberOfCluesLabel.attributedText = labelMaker("Hunt Size: ", labelDescriptor: "\(self.hunt!.clues.count)" + " Clues")
        self.huntDescriptionLabel.text = self.hunt!.desc
        
        let huntImage = hunt!.image
        huntImage.getDataInBackgroundWithBlock({ (data, error) in
            if error == nil {
                self.huntImageView.image = UIImage(data: data!)
            }
        })
    }
    
    func labelMaker(labelIndicator: String, labelDescriptor: String) -> NSMutableAttributedString {
        let boldFont = UIFont(name: boldLabelFont, size: smallLabelFontSize)
        let boldDictionary = [NSFontAttributeName: boldFont!] as [String: AnyObject]
        
        let normalFont = UIFont(name: labelFont, size: smallLabelFontSize)
        let normalDictionary = [NSFontAttributeName: normalFont!] as [String: AnyObject]
        
        let descriptor = NSAttributedString(string: labelDescriptor, attributes: normalDictionary)
        let label = NSMutableAttributedString(string: labelIndicator, attributes: boldDictionary)
        label.appendAttributedString(descriptor)
        
        return label
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