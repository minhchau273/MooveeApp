//
//  AuthenticationTestCase.swift
//  Movies
//
//  Created by EastAgile16 on 11/18/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import Parse

class AuthenticationTestCase: KIFTestCase {
  override func beforeEach() {
    super.beforeEach()
    tester.backToLoginViewAndLogOut()
  }
}

private extension KIFUITestActor {
  func backToLoginViewAndLogOut() {
    if PFUser.currentUser() != nil {
      PFUser.logOut()
    }
    backToHomeView()
    if isChangedToSignInMode {
      tapViewWithAccessibilityLabel("CANCEL")
    }
  }
}
