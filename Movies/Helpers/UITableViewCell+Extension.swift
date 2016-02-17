//
//  File.swift
//  Movies
//
//  Created by EastAgile16 on 11/12/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit

extension UITableViewCell {
  func setSeparatorFullWidth() {
    layoutMargins = UIEdgeInsetsZero
    preservesSuperviewLayoutMargins = false
    separatorInset = UIEdgeInsetsZero
  }
}
