//
//  Hunt.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class Hunt: PFObject, PFSubclassing {
    
    // MARK: Properties
    
    @NSManaged var creator: PFUser?
    @NSManaged var image: PFFile
    @NSManaged var name: String
    @NSManaged var clues: [Clue]
    @NSManaged var currentClue: Int
    @NSManaged var prize: String
    @NSManaged var desc: String
    
    // MARK: Parse
    
    static func parseClassName() -> String {
        return "Hunt"
    }

}