//
//  SHImagePicker.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-20.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

protocol SHImagePickerContext: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

class SHImagePicker: NSObject {
    
    // MARK: Alert
    
    static func imageAlert(vc: SHImagePickerContext) {
        
        let picker = UIImagePickerController()
        picker.delegate = vc
        
        let alertController = UIAlertController(title: "Please Pick Image Source", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default,handler: { action in
            picker.sourceType = .Camera
            vc.presentViewController(picker, animated: true, completion: nil)

        }))
        
        alertController.addAction(UIAlertAction(title: "Library", style: UIAlertActionStyle.Default,handler: { action in
            picker.sourceType = .PhotoLibrary
            vc.presentViewController(picker, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }

}