//
//  LoginScreenTests.swift
//  Movies
//
//  Created by EastAgile16 on 11/16/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import Parse
import OHHTTPStubs

@testable import Movies

class LoginScreenTests: AuthenticationTestCase {
  
  func testSignUpSuccessfully() {
    OHHTTPStubs.stubHomePage()
    tester.testSignUp(email: sampleSignUpUserEmail, password: sampleUserPassword, expectedMessage: "Popular")
    tester.deleteSignUpUser()
    OHHTTPStubs.removeAllStubs()
  }
  
  func testSignUpWithInvalidEmail() {
    tester.testSignUp(email: sampleInvalidEmail, password: sampleUserPassword, expectedMessage: "invalid email address")
    tester.returnFromErrorScreen()
  }
  
  func testSignUpWithExistedEmail() {
    tester.testSignUp(email: sampleSignInUserEmail, password: sampleUserPassword, expectedMessage: "username \(sampleSignInUserEmail) already taken")
    tester.returnFromErrorScreen()
  }
  
  func testSignInSuccessfully() {
    OHHTTPStubs.stubHomePage()
    tester.testSignIn(email: sampleSignInUserEmail, password: sampleUserPassword, expectedMessage: "Popular")
    OHHTTPStubs.removeAllStubs()
  }
  
  func testSignInFail() {
    tester.testSignIn(email: sampleSignInUserEmail, password: sampleWrongUserPassword, expectedMessage: "invalid login parameters")
    tester.returnFromErrorScreen()
  }
  
  func testRetrievePassWord() {
    tester.tapSignInFromPrepareLoginMode()
    tester.tapForgotPassword()
    tester.enterEmailAndSubmit()
  }
  
  func testSwitchModeUsingTopButton() {
    tester.tapSignInFromPrepareLoginMode()
    tester.tapSignUpTopButton()
    tester.tapSignInTopButton()
  }
  
}

// MARK: - Test Details

private extension KIFUITestActor {
  
  func returnFromErrorScreen() {
    // Tap anywhere to back
    tapScreenAtPoint(CGPoint(x: 0, y: 0))
  }
  
  // MARK: Test sign in
  
  func tapSignInFromPrepareLoginMode() {
    tapViewWithAccessibilityLabel("PREPARE SIGN IN")
    waitForViewWithAccessibilityLabel("SIGN IN")
    waitForViewWithAccessibilityLabel("FORGOT PASSWORD?")
  }
  
  func tapSignInFromLoginMode(expectedMessage expectedMessage: String) {
    tapViewWithAccessibilityLabel("SIGN IN")
    waitForViewWithAccessibilityLabel(expectedMessage)
  }
  
  func testSignIn(email email: String, password: String, expectedMessage: String) {
    tapSignInFromPrepareLoginMode()
    enterEmailAndPassword(email: email, password: password)
    tapSignInFromLoginMode(expectedMessage: expectedMessage)
  }
  
  // MARK: Test sign up
  
  func tapSignUpFromPrepareLoginMode() {
    tapViewWithAccessibilityLabel("SIGN UP")
    waitForViewWithAccessibilityLabel("SIGN UP")
  }
  
  func tapSignUpFromRegisterMode(expectedMessage expectedMessage: String) {
    tapViewWithAccessibilityLabel("SIGN UP")
    waitForViewWithAccessibilityLabel(expectedMessage)
  }
  
  func testSignUp(email email: String, password: String, expectedMessage: String) {
    tapSignUpFromPrepareLoginMode()
    enterEmailAndPassword(email: email, password: password)
    tapSignUpFromRegisterMode(expectedMessage: expectedMessage)
  }
  
  func deleteSignUpUser() {
    let user = PFUser.currentUser()
    user?.deleteInBackgroundWithBlock({ (success, error) -> Void in
      PFUser.logOut()
    })
  }
  
  // MARK: Retrieve password
  
  func tapForgotPassword() {
    tapViewWithAccessibilityLabel("FORGOT PASSWORD?")
    waitForViewWithAccessibilityLabel("SUBMIT")
  }
  
  func enterEmailAndSubmit() {
    isChangedToSignInMode = true
    tapViewWithAccessibilityLabel("email")
    clearTextFromAndThenEnterText(sampleSignInUserEmail, intoViewWithAccessibilityLabel: "email")
    tapViewWithAccessibilityLabel("SUBMIT")
    waitForViewWithAccessibilityLabel("Your request is successful. Please check your email.")
    returnFromErrorScreen()
  }
  
  // MARK: Switch mode using top button
  
  func tapSignUpTopButton() {
    tapViewWithAccessibilityLabel("Sign Up")
    waitForViewWithAccessibilityLabel("SIGN UP")
  }
  
  func tapSignInTopButton() {
    tapViewWithAccessibilityLabel("Sign In")
    waitForViewWithAccessibilityLabel("SIGN IN")
  }
  
}
