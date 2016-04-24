//
//  SHNavigationController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-23.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class SHNavigationController: UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.navigationBar.backgroundColor = UIColor.myColour1()
        self.navigationBar.tintColor = UIColor.myColour2()
    }

}