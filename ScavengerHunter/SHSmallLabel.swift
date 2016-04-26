//
//  SHSmallLabel.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-23.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHSmallLabel: SHLabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.font = UIFont(name: labelFont, size: labelFontSize * 0.67)
        self.adjustsFontSizeToFitWidth = true
    }

}
