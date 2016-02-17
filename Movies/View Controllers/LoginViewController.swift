//
//  LoginViewController.swift
//  Movies
//
//  Created by EastAgile16 on 11/9/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit
import SwiftSpinner
import Parse
import RealmSwift

class LoginViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var messageLabel: UILabel!
  
  @IBOutlet weak var secondaryButton: UIButton!
  
  @IBOutlet weak var primaryButton: UIButton!
  
  @IBOutlet weak var topButton: UIButton!
  
  @IBOutlet weak var bottomButton: UIButton!
  
  @IBOutlet weak var buttonGroupView: UIView!
  
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  
  var loginMode = LoginMode.PrepareLogin
  var boundHeight: CGFloat = 0
  var email: String? { return getTextField(0)?.text }
  var password: String? { return getTextField(1)?.text }
  
  // MARK: - Main functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialConfiguration()
    secondaryButton.accessibilityLabel = "PREPARE SIGN IN"
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if let user = PFUser.currentUser(), email = user.email {
      Helper.setDefaultRealmForUser(email)
      performSegueWithIdentifier("GoToHome", sender: self)
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func initialConfiguration() {
    boundHeight = view.layer.bounds.height
    tableViewHeightConstraint.constant = 0
    bottomConstraint.constant = boundHeight * 0.3
    messageLabel.text = ""
    tableView.setBorderColor(UIColor.whiteColor())
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    view.endEditing(true)
  }
  
  func handleKeyboardWillShow(notification: NSNotification) {
    if let info = notification.userInfo, keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
      if IDIOM == IPHONE {
        topConstraint.constant = boundHeight <= iPhone5Height ? topConstraintWithKeyboard : topConstraintWithoutKeyboard
      } else {
        topConstraint.constant = topConstraintWithKeyboardiPad
      }
      bottomConstraint.constant = keyboardFrame.size.height
    }
  }
  
  func handleKeyboardWillHide(notification: NSNotification) {
    bottomConstraint.constant = bottomConstraintWithoutKeyboard
    topConstraint.constant = topConstraintWithoutKeyboard
  }
  
  
  
}

// MARK: - Table View

extension LoginViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if loginMode == .PrepareLogin {
      return 0
    } else {
      if loginMode == .ForgotPassword && indexPath.row == 1 {
        return 0
      } else {
        return defaultTableViewCellHeight
      }
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("LoginCell", forIndexPath: indexPath) as! LoginCell
    cell.setSeparatorFullWidth()
    
    // Must have this silly line to set background color on iPad
    cell.backgroundColor = cell.contentView.backgroundColor
    
    if indexPath.row == 0 {
      cell.textField.placeholder = "email"
      cell.textField.text = email
      cell.textField.secureTextEntry = false
      cell.textField.keyboardType = .EmailAddress
      cell.textField.accessibilityLabel = "email"
    } else {
      cell.textField.placeholder = "password"
      cell.textField.text = password
      cell.textField.secureTextEntry = true
      cell.textField.accessibilityLabel = "password"
    }
    
    return cell
  }
  
  func getTextField(indexPathRow: Int) -> UITextField? {
    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPathRow, inSection: 0)) as! LoginCell! {
      return cell.textField
    }
    return nil
  }
  
}

//MARK: - Handle Button

extension LoginViewController {
  
  @IBAction func onPrimaryButton(sender: UIButton) {
    view.endEditing(true)
    switch loginMode {
    case .PrepareLogin:   showSignUpMode()
    case .SignIn:         processSigningIn()
    case .SignUp:         processRegistration()
    case .ForgotPassword: processPasswordRetrieval()
    }
  }
  
  @IBAction func onSecondaryButton(sender: UIButton) {
    if loginMode == .PrepareLogin {
      showSignInMode()
    } else {
      showPrepareMode()
    }
  }
  
  @IBAction func onTopButton(sender: UIButton) {
    if loginMode == .SignUp {
      showSignInMode()
    } else if loginMode == .SignIn {
      showSignUpMode()
    }
  }
  
  @IBAction func onBottomButton(sender: UIButton) {
    if loginMode == .PrepareLogin {
      Helper.setDefaultRealmForUser("default")
      performSegueWithIdentifier("GoToHome", sender: self)
    } else if loginMode == .SignIn {
      showForgotPasswordMode()
    }
  }
  
}

//MARK: - Display suitable view for each login mode

extension LoginViewController {
  
  func reloadTableViewWithHeight(height: CGFloat) {
    tableViewHeightConstraint.constant = height
    tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Top)
    bottomConstraint.constant = height != 0 ? bottomConstraintWithoutKeyboard : self.boundHeight * 0.3
  }
  
  func showPrepareMode() {
    loginMode = .PrepareLogin
    primaryButton.backgroundColor = Color.secondaryButtonColor
    secondaryButton.setTitle("SIGN IN", forState: UIControlState.Normal)
    secondaryButton.accessibilityLabel = "PREPARE SIGN IN"
    primaryButton.setTitle("SIGN UP", forState: UIControlState.Normal)
    bottomButton.setTitle("OR SKIP ⇥", forState: UIControlState.Normal)
    topButton.hidden = true
    bottomButton.hidden = false
    messageLabel.text = ""
    reloadTableViewWithHeight(0)
  }
  
  func showSignUpMode() {
    loginMode = .SignUp
    primaryButton.backgroundColor = Color.primaryColor
    topButton.setTitle("Sign In", forState: UIControlState.Normal)
    secondaryButton.setTitle("CANCEL", forState: UIControlState.Normal)
    secondaryButton.accessibilityLabel = "CANCEL"
    primaryButton.setTitle("SIGN UP", forState: UIControlState.Normal)
    topButton.hidden = false
    bottomButton.hidden = true
    reloadTableViewWithHeight(2 * defaultTableViewCellHeight)
  }
  
  func showSignInMode() {
    loginMode = .SignIn
    primaryButton.backgroundColor = Color.primaryColor
    topButton.setTitle("Sign Up", forState: UIControlState.Normal)
    secondaryButton.setTitle("CANCEL", forState: UIControlState.Normal)
    secondaryButton.accessibilityLabel = "CANCEL"
    primaryButton.setTitle("SIGN IN", forState: UIControlState.Normal)
    bottomButton.setTitle("FORGOT PASSWORD?", forState: UIControlState.Normal)
    topButton.hidden = false
    bottomButton.hidden = false
    reloadTableViewWithHeight(2 * defaultTableViewCellHeight)
  }
  
  func showForgotPasswordMode() {
    loginMode = .ForgotPassword
    primaryButton.backgroundColor = Color.primaryColor
    messageLabel.text = "Please enter your email so we can send you link to reset password"
    topButton.hidden = true
    bottomButton.hidden = true
    primaryButton.setTitle("SUBMIT", forState: UIControlState.Normal)
    reloadTableViewWithHeight(defaultTableViewCellHeight)
  }
  
}

// MARK: - Login Process

extension LoginViewController {
  
  func processSigningIn() {
    if let email = email, password = password {
      SwiftSpinner.show("Siging in...")
      
      PFUser.logInWithUsernameInBackground(email, password: password, block: { (user: PFUser?, error: NSError?) -> Void in
        self.setDefaultRealmThenTransferToHome(error: error, email: email)
      })
    }
  }
  
  func processRegistration() {
    if let email = email, password = password {
      SwiftSpinner.show("Registering...")
      
      let user = PFUser()
      user.username = email
      user.email = email
      user.password = password
      
      user.signUpInBackgroundWithBlock {
        (succeeded: Bool, error: NSError?) -> Void in
        self.setDefaultRealmThenTransferToHome(error: error, email: email)
      }
    }
  }
  
  func setDefaultRealmThenTransferToHome(error error: NSError?, email: String) {
    if let error = error {
      SwiftSpinner.handleUserInfoError(error)
    } else {
      Helper.setDefaultRealmForUser(email)
      
      if loginMode == .SignIn {
        SwiftSpinner.show("Synchronizing data...")
        syncDataFromParse({ (success) -> () in
          if !success {
            SwiftSpinner.show("Cannot sync your data. Please try again later.", animated: false).addTapHandler(
              { SwiftSpinner.hide() }, subtitle: "Tap to try again"
            )
          }
          self.performSegueWithIdentifier("GoToHome", sender: self)
        })
      } else {
        performSegueWithIdentifier("GoToHome", sender: self)
      }
    }
  }
  
  func processPasswordRetrieval() {
    SwiftSpinner.show("Sending you instructions...")
    
    guard let email = email else {
      messageLabel.text = "Please enter your email"
      return
    }
    
    PFUser.requestPasswordResetForEmailInBackground(email) { (successed, error) -> Void in
      if let error = error {
        SwiftSpinner.handleUserInfoError(error)
      } else {
        SwiftSpinner.show("Your request is successful. Please check your email.", animated: false).addTapHandler(
          { SwiftSpinner.hide() }, subtitle: "Tap to return"
        )
      }
    }
  }
  
}

// MARK: - Sync Data
extension LoginViewController {
  
  func deleteOldData() {
    let realm = try! Realm()
    try! realm.write {
      realm.deleteAll()
    }
  }
  
  func syncDataFromParse(completion: (success: Bool) -> ()) {
    deleteOldData()
    let query = PFQuery(className: "Movie")
    if let user = PFUser.currentUser() {
      query.whereKey("parent", equalTo: user)
      query.includeKey("trailerList")
      query.includeKey("reviewList")
      query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        if error == nil {
          if let objects = objects {
            for object in objects {
              let movie = self.createMovieFromParseObject(object)
              movie.posterLocalPath = Helper.savePosterToDocumentsDirectory(movie)
              movie.saveToRealm()
            }
            completion(success: true)
          }
        } else {
          completion(success: false)
        }
      }
    }
  }
  
  func createMovieFromParseObject(object: PFObject) -> Movie {
    let movie = Movie(object: object)
    
    // Get trailers
    if let trailerList = object.objectForKey("trailerList") as? [PFObject] {
      for item in trailerList {
        let newTrailer = Trailer(object: item)
        movie.trailers.append(newTrailer)
      }
    }
    
    // Get reviews
    if let reviewList = object.objectForKey("reviewList") as? [PFObject] {
      for item in reviewList {
        movie.reviews.append(Review(object: item))
      }
    }
    
    return movie
  }
  
}
