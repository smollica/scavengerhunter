//
//  AppDelegate.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.setApplicationId("akecYT0cWwQyHap9cKZzySETecY1VloS1WFBqL6M", clientKey: "Gbd6l3zYJLBgZa1RAXYDCXqh6JAb24lbiX4V36P7")
        
//        let configuration = ParseClientConfiguration {
//            $0.applicationId = "akecYT0cWwQyHap9cKZzySETecY1VloS1WFBqL6M"
//            $0.server = "Gbd6l3zYJLBgZa1RAXYDCXqh6JAb24lbiX4V36P7"
//        }
//        Parse.initializeWithConfiguration(configuration)
        
        return true
    }

}