//
//  UITableView+Extension.swift
//  Movies
//
//  Created by EastAgile16 on 11/12/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit

extension UITableView {
  func setBorderColor(color: UIColor, width: CGFloat = 1) {
    separatorColor = color
    layer.borderColor = color.CGColor
    layer.borderWidth = width
  }
}
