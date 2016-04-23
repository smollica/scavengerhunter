//
//  SHButton.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-19.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.grayColor()
        self.tintColor = UIColor.blueColor()
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.5
        
        if (self.superview != nil) {
            self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.superview!, attribute: NSLayoutAttribute.Width, multiplier: 0.2, constant: 0))
        }
    }

}