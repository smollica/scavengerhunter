//
//  SHLargeButton.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-24.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHLargeButton: SHButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderWidth = borderWidth
        self.layer.shadowOffset = CGSize(width: 7.5, height: 7.5)
        self.titleLabel!.font = UIFont(name: buttonFont, size: buttonFontSize + 20)
    }

}