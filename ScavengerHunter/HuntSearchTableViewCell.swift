//
//  HuntSearchTableViewCell.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HuntSearchTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var huntImageView: SHImage!
    @IBOutlet weak var huntNameLabel: SHLabel!
    @IBOutlet weak var huntPrizeLabel: SHSmallLabel!
    @IBOutlet weak var huntCreatorLabel: SHSmallLabel!
    @IBOutlet weak var numberOfCluesLabel: SHSmallLabel!

}