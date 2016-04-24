//
//  SHImageButton.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-19.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHImageButton: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.userInteractionEnabled = true
        
        self.tintColor = UIColor.myColour2()
        self.layer.borderColor = UIColor.myColour4().CGColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius * 2
        self.layer.shadowColor = UIColor.myColour3().CGColor
        self.layer.shadowOffset = CGSize(width: shadowOffset.width * 2, height: shadowOffset.height * 2)
        self.layer.shadowOpacity = shadowOpacity * 1.25
    }

}