//
//  SHLargeLabel.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-26.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHLargeLabel: SHLabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = UIFont(name: labelFont, size: labelFontSize * 2)
    }
    
}