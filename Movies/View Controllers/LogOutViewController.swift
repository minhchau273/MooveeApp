//
//  LogOutViewController.swift
//  Movies
//
//  Created by EastAgile16 on 11/13/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit
import SwiftSpinner
import Parse

class LogOutViewController: UIViewController {
  
  @IBOutlet weak var emailLabel: UILabel!
  
  @IBOutlet weak var actionView: UIView!
  
  @IBOutlet weak var actionImage: UIImageView!
  
  @IBOutlet weak var actionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadUI()
  }
  
  func loadUI() {
    if let user = PFUser.currentUser() {
      emailLabel.hidden = false
      emailLabel.text = user.email
      actionImage.image = UIImage(named: "SignOut")
      actionLabel.text = "Sign out"
    } else {
      emailLabel.hidden = true
      actionImage.image = UIImage(named: "SignIn")
      actionLabel.text = "Sign in"
    }
    
    actionView.setBorder(color: Color.actionButtonColor, radius: 6)
    
    // Add gesture for action button
    let tapGesture = UITapGestureRecognizer(target: self, action: "handleActionButton:")
    actionView.addGestureRecognizer(tapGesture)
    actionView.userInteractionEnabled = true
  }
  
  func handleActionButton(sender: UITapGestureRecognizer) {
    if PFUser.currentUser() != nil {
      SwiftSpinner.show("Signing out...")
      PFUser.logOutInBackgroundWithBlock { (error) -> Void in
        if let error = error {
          SwiftSpinner.handleUserInfoError(error)
        } else {
          SwiftSpinner.hide()
          self.backToLoginScreen()
        }
      }
    } else {
      backToLoginScreen()
    }
  }
  
  func backToLoginScreen() {
    if let revealViewController = self.revealViewController() {
      revealViewController.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
}
