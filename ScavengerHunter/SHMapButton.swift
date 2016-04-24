//
//  SHMapButton.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-23.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

let buttonSpacing = CGFloat(30)

class SHMapButton: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.userInteractionEnabled = true
        
        self.backgroundColor = UIColor.myColour5()
        self.tintColor = UIColor.myColour4()
        self.layer.borderColor = UIColor.myColour4().CGColor
        self.layer.borderWidth = borderWidth / 1.5
        self.layer.cornerRadius = buttonSpacing / 2
        self.layer.shadowColor = UIColor.myColour3().CGColor
        self.layer.shadowOffset = CGSize(width: shadowOffset.width / 2, height: shadowOffset.height / 2)
        self.layer.shadowOpacity = shadowOpacity / 2
    }
    
    func autoLayout() {
        self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: buttonSpacing))
        self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: buttonSpacing))
    }

}