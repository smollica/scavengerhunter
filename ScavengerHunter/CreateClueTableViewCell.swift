//
//  CreateClueTableViewCell.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseUI

protocol CreateClueTableViewCellDelegate {
    func reloadTable()
    func triggerClueDetailSegue(sender: UIButton)
}

class CreateClueTableViewCell: UITableViewCell, MKMapViewDelegate {
    
    var delegate: CreateClueTableViewCellDelegate!
    
    // MARK: Outlets
    
    @IBOutlet weak var clueNumberLabel: SHLabel!
    @IBOutlet weak var clueImageView: SHImage!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var clueLabel: SHLabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var editButton: SHButton!
    @IBOutlet weak var editButtonTopConstraint: NSLayoutConstraint!
    
    // MARK: Properties

    var clue: Clue?
    
    // MARK: Actions
    
    @IBAction func expandButtonPressed(sender: AnyObject) {
        if !self.clue!.isExpanded {
            self.clue!.isExpanded = true
            self.expandButton.setImage(UIImage(named: "minus_math-25"), forState: UIControlState.Normal)
            self.delegate?.reloadTable()
            
        } else if self.clue!.isExpanded {
            self.clue!.isExpanded = false
            self.expandButton.setImage(UIImage(named: "plus_math-25"), forState: UIControlState.Normal)
            self.delegate?.reloadTable()
        }
    }
    
    @IBAction func editClueButtonPressed(sender: AnyObject) {
        self.delegate.triggerClueDetailSegue(self.editButton)
    }

}