//
//  Clue.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class Clue: PFObject, PFSubclassing {
    
    // MARK: Properties
    
    @NSManaged var number: Int
    @NSManaged var type: String
    @NSManaged var image: PFFile
    @NSManaged var clue: String
    @NSManaged var solution: PFGeoPoint
    @NSManaged var solutionText: String
    @NSManaged var accuracy: Double
    @NSManaged var hint: String
    @NSManaged var isExpanded: Bool
    
    // MARK: Parse
    
    static func parseClassName() -> String {
        return "Clue"
    }
    
    // MARK: Init
    
//    init(type: String, clue: String, solution: PFGeoPoint) {
//        super.init()
//        self.type = type
//        self.clue = clue
//        self.solution = solution
//        self.isExpanded = true
//    }
    
}