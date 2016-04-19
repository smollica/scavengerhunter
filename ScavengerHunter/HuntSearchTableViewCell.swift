//
//  HuntSearchTableViewCell.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class HuntSearchTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var huntImageView: PFImageView!
    @IBOutlet weak var huntNameLabel: UILabel!
    @IBOutlet weak var numberOfCluesLabel: UILabel!

}