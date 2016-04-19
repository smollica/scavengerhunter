//
//  Clue.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class Clue: PFObject {
    
    // MARK: Properties
    
    var number: Int
    var type: String
    var image: PFFile?
    var clue: String
    var solution: PFGeoPoint
    var hint: String?
    
    // MARK: Init
    
    init(number: Int, type: String, clue: String, solution: PFGeoPoint) {
        self.number = number
        self.type = type
        self.clue = clue
        self.solution = solution
        super.init()
    }
    
}