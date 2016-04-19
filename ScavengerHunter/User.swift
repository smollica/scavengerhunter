//
//  User.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
    
    // MARK: Properties
    
    var picture: PFFile?
    var displayName: String
    var age: NSDate
    
    // MARK: Init
    
    init(displayName: String, age: NSDate) {
        self.displayName = displayName
        self.age = age
        super.init()
    }

}