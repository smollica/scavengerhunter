//
//  SHScroll.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-24.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHScroll: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.image = UIImage(named: "scroll")
        self.alpha = 0.6
    }

}
