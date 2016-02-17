//
//  Credentials.swift
//  Movies
//
//  Created by EastAgile16 on 10/27/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation

class Credentials {
  static let sharedInstance = Credentials()
  
  var config = [String: String]()
  
  var apiKey: String {
    return config["api_key"] as String!
  }
  
  var parseApplicationId: String {
    return config["parse_application_id"] as String!
  }
  
  var parseClientKey: String {
    return config["parse_client_key"] as String!
  }
}
