//
//  SwiftSpinner+Extension.swift
//  Movies
//
//  Created by EastAgile16 on 11/13/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import SwiftSpinner

extension SwiftSpinner {
  public class func handleUserInfoError(error: NSError) {
    if let message = error.userInfo["error"] {
      show("\(message)", animated: false).addTapHandler(
        { hide() }, subtitle: "Tap to try again"
      )
    } else {
      hide()
    }
  }
}

