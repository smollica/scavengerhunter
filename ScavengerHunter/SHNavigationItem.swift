//
//  SHNavigationItem.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-23.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHNavigationItem: UINavigationItem {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backBarButtonItem?.tintColor = UIColor.myColour2()
    }

}