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
let buttonFontSize: CGFloat = 20
let buttonFont = "ArialRoundedMTBold"

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
        self.titleLabel!.adjustsFontSizeToFitWidth = true
    }
    
    func autoLayout(superView: UIView) {
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.Width, multiplier: 0.275, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Width, multiplier: 0.275 * 0.35, constant: 0))
    }

}