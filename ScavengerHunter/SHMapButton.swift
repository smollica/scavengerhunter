//
//  SHMapButton.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-23.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHMapButton: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.userInteractionEnabled = true
        
        if (self.superview != nil) {
            self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.superview!, attribute: NSLayoutAttribute.Width, multiplier: 0.25, constant: 0))
            self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.superview!, attribute: NSLayoutAttribute.Width, multiplier: 0.25, constant: 0))
        }
    }

}