//
//  Colours.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-22.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

extension UIColor {
    class func myColour2() -> UIColor {
        //rust
        let myRed:CGFloat = 155 / 255
        let myGreen:CGFloat = 79 / 255
        let myBlue:CGFloat = 15 / 255

        return UIColor(red: myRed, green: myGreen, blue: myBlue, alpha: 1)
    }
    
    class func myColour1() -> UIColor {
        //l-gold
        let myRed:CGFloat = 245 / 255
        let myGreen:CGFloat = 225 / 255
        let myBlue:CGFloat = 86 / 255

        return UIColor(red: myRed, green: myGreen, blue: myBlue, alpha: 1)
    }
    
    class func myColour4() -> UIColor {
        //asphalt
        let myRed:CGFloat = 50 / 255
        let myGreen:CGFloat = 56 / 255
        let myBlue:CGFloat = 77 / 255

        return UIColor(red: myRed, green: myGreen, blue: myBlue, alpha: 0.8)
    }
    
    class func myColour3() -> UIColor {
        //shadow
        let myRed:CGFloat = 33 / 255
        let myGreen:CGFloat = 31 / 255
        let myBlue:CGFloat = 48 / 255
        
        return UIColor(red: myRed, green: myGreen, blue: myBlue, alpha: 1)
    }
    
    class func myColour5() -> UIColor {
        //ivory
        let myRed:CGFloat = 241 / 255
        let myGreen:CGFloat = 243 / 255
        let myBlue:CGFloat = 206 / 255
        
        return UIColor(red: myRed, green: myGreen, blue: myBlue, alpha: 0.25)
    }
    
    class func gradientPoint(factor factor:CGFloat, color1:UIColor, color2:UIColor) -> UIColor
    {
        let c1 = color1.getComponents()
        let c2 = color2.getComponents()
        
        let newR = c1.red + (factor*(c2.red-c1.red))
        let newG = c1.green + (factor*(c2.green-c1.green))
        let newB = c1.blue + (factor*(c2.blue-c1.blue))
        
        return UIColor.init(red: newR, green: newG, blue: newB, alpha: 0.6)
    }
    
    func getComponents() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)
    {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
}

/*
 combo1:
 bl-gr  217ca3  33  124 163
 musta  e29937  226 153 55
 asph   32384d  50  56  77
 shadow 211f30  33  31  48
 
 combo2:
 red    f62a00  246 42  0
 navy   00293c  0   41  60
 l-blue 1e656d  30  101 109
 ivory  f1f3c3  241 243 206
 
 combo3:
 yellow f9ba32  249 186 50
 blue   426e86  66  110 134
 coal   2f3131  47  49  49
 bone   f8f1e5  248 241 229
 
 combo4:
 blue   344d90  52  77  144
 l-blue 5cc5ef  92  197 239
 orange e7552c  231 85  44
 l-ora  ffb745  255 183 69
 
 other:
 rust   9b4f0f  155 79  15 
 gold   c99e10  201 158 16
 l-gold f5e356  245 225 86
 
 fonts:
        ChalkboardSE-Regular (or Bold)
        Copperplate
        DevanagariSangamMN
        BanglaSangamMN
        ArialRoundedMTBold
        AmericanTypewriter-Bold
 */