//
//  SHTextField.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-23.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.myColour5()
        self.tintColor = UIColor.myColour2()
        self.layer.borderColor = UIColor.myColour4().CGColor
        self.layer.borderWidth = borderWidth / 2
        self.layer.cornerRadius = cornerRadius / 2
        self.layer.shadowColor = UIColor.myColour3().CGColor
        self.layer.shadowOffset = CGSize(width: shadowOffset.width / 2, height: shadowOffset.height / 2)
        self.layer.shadowOpacity = shadowOpacity / 2
        self.font = UIFont(name: labelFont, size: labelFontSize * 0.67)
    }

}