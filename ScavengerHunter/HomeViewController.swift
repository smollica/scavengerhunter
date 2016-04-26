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
    
    // MARK: Properties
    
    var videoPlayer: AVPlayer?
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingIndicator.hidden = true
        
        transition()
        
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
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("treasure", withExtension: "mp4")!
        
        videoPlayer = AVPlayer(URL: videoURL)
        videoPlayer?.actionAtItemEnd = .None
        videoPlayer?.muted = true

        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1

        playerLayer.frame = view.frame
        playerLayer.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.layer.addSublayer(playerLayer)
        videoPlayer?.play()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.loopVideo), name: AVPlayerItemDidPlayToEndTimeNotification,object: nil)
    }
    
    func transition() {
        let topCover = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        topCover.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(topCover)
        
        let cover = UIImageView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20))
        cover.image = UIImage(named: "background3")
        self.view.addSubview(cover)
        
        let logoY = (self.view.frame.height / 2) - (175 / 2) + (20 / 2)
        let logo = UIImageView(frame: CGRect(x: 38, y: logoY, width: self.view.frame.width - (38 * 2), height: 175))
        logo.image = UIImage(named: "treasurehunter2")
        logo.contentMode = .ScaleAspectFill
        logo.clipsToBounds = true
        self.view.addSubview(logo)
        
        UIView.animateWithDuration(0.75, delay: 0, options: .CurveEaseIn, animations: {
            topCover.alpha = 0
            cover.alpha = 0
            logo.alpha = 0
        }) { (finished) in
            topCover.removeFromSuperview()
            cover.removeFromSuperview()
            logo.removeFromSuperview()
        }
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