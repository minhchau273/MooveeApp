//
//  KIF+SwiftExtension.swift
//  Movies
//
//  Created by EastAgile16 on 11/4/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import OHHTTPStubs
import Parse

@testable import Movies

var isChangedToSignInMode = false

extension XCTestCase {
  
  var tester: KIFUITestActor { return tester() }
  var system: KIFSystemTestActor { return system() }
  
  private func tester(file : String = __FILE__, _ line : Int = __LINE__) -> KIFUITestActor {
    return KIFUITestActor(inFile: file, atLine: line, delegate: self)
  }
  
  private func system(file : String = __FILE__, _ line : Int = __LINE__) -> KIFSystemTestActor {
    return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
  }
  
}

extension KIFUITestActor {
  
  func loginIfNeeded() {
    if PFUser.currentUser() == nil {
      backToHomeView()
      if isChangedToSignInMode {
        tapViewWithAccessibilityLabel("CANCEL")
      }
      login()
    }
  }
  
  func login() {
    tapViewWithAccessibilityLabel("PREPARE SIGN IN")
    enterEmailAndPassword(email: sampleSignInUserEmail, password: sampleUserPassword)
    tapViewWithAccessibilityLabel("SIGN IN")
  }
  
  func enterEmailAndPassword(email email: String, password: String) {
    tapViewWithAccessibilityLabel("email")
    clearTextFromAndThenEnterText(email, intoViewWithAccessibilityLabel: "email")
    clearTextFromAndThenEnterText(password, intoViewWithAccessibilityLabel: "password")
    isChangedToSignInMode = true
  }
  
  func backToHomeView() {
    let rootVC = UIApplication.sharedApplication().delegate?.window??.rootViewController
    rootVC?.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
    if PFUser.currentUser() != nil {
      tapViewWithAccessibilityLabel("Popular")
    }
  }
  
}
