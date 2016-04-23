//
//  Colours.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-22.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

extension UIColor {
    class func myColour1() -> UIColor {
        let myRed = CGFloat(0)
        let myGreen = CGFloat(0)
        let myBlue = CGFloat(0)
        let myAlpha = CGFloat(0)

        return UIColor(red: myRed, green: myGreen, blue: myBlue, alpha: myAlpha)
    }
    
    class func myColour2() -> UIColor {
        let myRed = CGFloat(0)
        let myGreen = CGFloat(0)
        let myBlue = CGFloat(0)
        let myAlpha = CGFloat(0)
        
        return UIColor(red: myRed, green: myGreen, blue: myBlue, alpha: myAlpha)
    }
    
    class func myColour3() -> UIColor {
        let myRed = CGFloat(0)
        let myGreen = CGFloat(0)
        let myBlue = CGFloat(0)
        let myAlpha = CGFloat(0)
        
        return UIColor(red: myRed, green: myGreen, blue: myBlue, alpha: myAlpha)
    }
    
    class func gradientPoint(factor factor:CGFloat, color1:UIColor, color2:UIColor) -> UIColor
    {
        let c1 = color1.getComponents()
        let c2 = color2.getComponents()
        
        let newR = c1.red + (factor*(c2.red-c1.red))
        let newG = c1.green + (factor*(c2.green-c1.green))
        let newB = c1.blue + (factor*(c2.blue-c1.blue))
        
        return UIColor.init(red: newR, green: newG, blue: newB, alpha: 1.0)
    }
    
    func getComponents() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)
    {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
}