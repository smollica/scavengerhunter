//
//  HomeViewController.swift
//  ScavengerHunter
//
//  Created by Sergio Mollica on 2016-04-18.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var logoImageView: SHLogo!
    @IBOutlet weak var signInButton: SHLargeButton!
    @IBOutlet weak var signUpButton: SHLargeButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var videoView: UIView!
    
    // MARK: Properties
    
    var videoPlayer: AVPlayer?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingIndicator.hidden = true
        
        playVideo()
    }
    
    // MARK: Actions
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        if let _ = PFUser.currentUser() {
            self.performSegueWithIdentifier("signInSegue", sender: self)
        } else {
            loginAlert()
        }
    }
    
    // MARK: Helper Functions
    
    func playVideo() {
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("tropical", withExtension: "mp4")!
        
        videoPlayer = AVPlayer(URL: videoURL)
        videoPlayer?.actionAtItemEnd = .None
        videoPlayer?.muted = true

        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1

        playerLayer.frame = view.frame
        playerLayer.bounds = CGRect(x: -300, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.layer.addSublayer(playerLayer)
        videoPlayer?.play()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.loopVideo), name: AVPlayerItemDidPlayToEndTimeNotification,object: nil)
    }
    
    // MARK: NotificationCenter

    func loopVideo() {
        videoPlayer?.seekToTime(kCMTimeZero)
        videoPlayer?.play()
        }

    // MARK: Alerts

    func loginAlert() {
        let alertController = UIAlertController(title: "Log In Please", message:"", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "username"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "password"
            textField.secureTextEntry = true
        }
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default, handler: { action in
            let usernameTextField = alertController.textFields?.first
            let passwordTextField = alertController.textFields?.last
            self.signInButton.hidden = true
            self.signUpButton.hidden = true
            self.loadingIndicator.hidden = false
            self.loadingIndicator.startAnimating()
            
            PFUser.logInWithUsernameInBackground(usernameTextField!.text!, password: passwordTextField!.text!, block: { (user, error) in
                if user != nil {
                    self.signInButton.hidden = false
                    self.signUpButton.hidden = false
                    self.loadingIndicator.hidden = true
                    self.loadingIndicator.stopAnimating()
                    self.performSegueWithIdentifier("signInSegue", sender: self)
                }  else if error != nil {
                    self.errorAlert(error!)
                }
            })
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Unwind Segue
    
    @IBAction func unwindHome(segue: UIStoryboardSegue) {
        //do nothing here
    }    
    
    // MARK: Alert
    
    func errorAlert(error: NSError) {
        let alertController = UIAlertController(title: "Error!", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}