//
//  UIView+Extension.swift
//  Movies
//
//  Created by EastAgile16 on 11/5/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit

extension UIView {
  func setBorder(color color: UIColor, radius: CGFloat, width: CGFloat = 1) {
    clipsToBounds = true
    layer.borderColor = color.CGColor
    layer.cornerRadius = radius
    layer.borderWidth = width
  }
}
