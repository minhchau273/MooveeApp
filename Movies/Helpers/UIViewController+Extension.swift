//
//  UIViewController+Extension.swift
//  Movies
//
//  Created by EastAgile16 on 11/5/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit

extension UIViewController {
  func showMessageBox(title title: String, message: String?, actionTitle: String) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    ac.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
    presentViewController(ac, animated: true, completion: nil)
  }
  
  func showNetworkErrorAlert() {
    showMessageBox(title: networkErrorTitle, message: networkErrorMessage, actionTitle: "OK")
  }
}
