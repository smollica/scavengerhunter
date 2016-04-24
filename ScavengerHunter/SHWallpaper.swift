//
//  SHWallpaper.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-24.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHWallpaper: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.image = UIImage(named: "background1")
        self.alpha = 0.05
    }
}