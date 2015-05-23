//
//  LoginViewController.swift
//  GeoTweet
//
//  Created by Vishnu on 23/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    var tweets = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            // play with Twitter session
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
            self.presentViewController(controller, animated: true, completion: nil)
            
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }

}
