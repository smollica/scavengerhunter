//
//  SHButton.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-19.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

let borderWidth: CGFloat = 2
let cornerRadius: CGFloat = 10
let shadowOffset = CGSize(width: 5, height: 5)
let shadowOpacity: Float = 0.5
let buttonFontSize: CGFloat = 25
let buttonFont = "ChalkboardSE-Regular"

class SHButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.myColour1()
        self.tintColor = UIColor.myColour2()
        self.layer.borderColor = UIColor.myColour4().CGColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor.myColour3().CGColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.titleLabel!.font = UIFont(name: buttonFont, size: buttonFontSize)

        if (self.superview != nil) {
            self.superview!.translatesAutoresizingMaskIntoConstraints = false
            self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.superview!, attribute: NSLayoutAttribute.Width, multiplier: 0.3, constant: 0))
            self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.3, constant: 0))
        }
    }

}