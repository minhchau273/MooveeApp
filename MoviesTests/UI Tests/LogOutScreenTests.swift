//
//  LogOutScreenTests.swift
//  Movies
//
//  Created by EastAgile16 on 11/18/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import Parse
import OHHTTPStubs

@testable import Movies

class LogOutScreenTests: AuthenticationTestCase {
  
  func testSignOut() {
    tester.login()
    tester.tapMenuButton()
    tester.tapSignOut()
  }
  
  func testViewMenuWithoutSignedIn() {
    tester.tapSkip()
    tester.tapMenuButtonWithoutSignedIn()
    tester.tapSignIn()
  }
  
}

// MARK: - Test Details

private extension KIFUITestActor {
  
  // MARK: Sign out
  
  func tapMenuButton() {
    tapViewWithAccessibilityLabel("MENU BUTTON")
    waitForViewWithAccessibilityLabel(sampleSignInUserEmail)
    waitForViewWithAccessibilityLabel("Sign out")
  }
  
  func tapSignOut() {
    tapViewWithAccessibilityLabel("Sign out")
    waitForViewWithAccessibilityLabel("LOGO")
  }
  
  // MARK: View Menu without signed in
  
  func tapSkip() {
    isChangedToSignInMode = false
    OHHTTPStubs.stubHomePage()
    tapViewWithAccessibilityLabel("OR SKIP ⇥")
    waitForViewWithAccessibilityLabel("Popular")
    OHHTTPStubs.removeAllStubs()
  }
  
  func tapMenuButtonWithoutSignedIn() {
    tapViewWithAccessibilityLabel("MENU BUTTON")
    waitForViewWithAccessibilityLabel("Sign in")
  }
  
  func tapSignIn() {
    tapViewWithAccessibilityLabel("Sign in")
    waitForViewWithAccessibilityLabel("LOGO")
  }
  
}
