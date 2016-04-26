//
//  SHBackground.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-24.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHBackground: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.image = UIImage(named: "background3")
        self.alpha = 1.0
    }
    
}