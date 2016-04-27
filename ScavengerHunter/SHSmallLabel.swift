//
//  SHSmallLabel.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-23.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

let smallLabelFontSize: CGFloat = labelFontSize * 0.67

class SHSmallLabel: SHLabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = UIFont(name: labelFont, size: smallLabelFontSize)
    }

}