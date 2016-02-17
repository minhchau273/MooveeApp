//
//  DateFormatter.swift
//  Movies
//
//  Created by EastAgile16 on 10/27/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation

class DateFormatter {
  static func formatterFromString(format: String) -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = format
    return formatter
  }
  
  static var yyyy_MM_dd = DateFormatter.formatterFromString("yyyy-MM-dd")
  static var MMMM_yyyy   = DateFormatter.formatterFromString("MMMM yyyy")
  static var yyyy       = DateFormatter.formatterFromString("yyyy")
}
