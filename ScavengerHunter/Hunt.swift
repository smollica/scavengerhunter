//
//  Hunt.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

class Hunt: PFObject {
    
    // MARK: Properties
    
    let creator: PFUser?
    var image: PFFile?
    var name: String
    var clues = [Clue]()
    var currentClue: Int = 0
    var prize: String
    var accuracy: Double
    var desc: String
    
    // MARK: Init
    
    init(name: String, accuracy: Double, prize: String, desc: String) {
        self.creator = PFUser.currentUser()
        self.name = name
        self.accuracy = accuracy
        self.prize = prize
        self.desc = desc
        super.init()
    }

}