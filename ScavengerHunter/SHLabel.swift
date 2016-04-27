//
//  SHLabel.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-22.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

let labelFontSize: CGFloat = buttonFontSize
let labelFont = "Copperplate"
let boldLabelFont = "Copperplate-Bold"

class SHLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.font = UIFont(name: labelFont, size: labelFontSize)
    }

}