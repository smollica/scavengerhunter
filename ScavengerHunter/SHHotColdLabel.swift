//
//  SHHotColdLabel.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-23.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHHotColdLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.userInteractionEnabled = true
        
        self.text = defaultHolColdText
        
        self.font = UIFont(name: labelFont, size: labelFontSize * 1.5)
        self.adjustsFontSizeToFitWidth = true
    }

}