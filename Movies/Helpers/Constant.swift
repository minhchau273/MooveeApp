//
//  Router.swift
//  Movies
//
//  Created by EastAgile16 on 10/28/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation
import Alamofire

let apiBaseUrl = "http://api.themoviedb.org/3"
let IDIOM = UI_USER_INTERFACE_IDIOM()
let IPHONE = UIUserInterfaceIdiom.Phone
let iPhone5Height: CGFloat = 568

// MARK: API entry point
public enum Router: URLRequestConvertible {
  case ListMovies(type: String, params: [String: AnyObject]?)
  case MovieDetail(id: Int)
  case Trailers(id: Int)
  case Reviews(id: Int, params: [String: AnyObject]?)
  case BaseImageUrl
  
  public var URLRequest: NSMutableURLRequest {
    let result: (method: String, path: String, params: [String: AnyObject]?) = {
      switch self {
      case .ListMovies(let type, let parameters): return ("GET", "/movie/\(type)", parameters)
      case .MovieDetail(let id): return ("GET", "/movie/\(id)", nil)
      case .Trailers(let id): return ("GET", "/movie/\(id)/videos", nil)
      case .Reviews(let id, let parameters): return ("GET", "/movie/\(id)/reviews", parameters)
      case .BaseImageUrl: return ("GET", "/configuration", nil)
      }
      }()
    
    let baseUrl = NSURL(string: apiBaseUrl)!
    let baseUrlRequest = NSMutableURLRequest(URL: baseUrl.URLByAppendingPathComponent(result.path))
    baseUrlRequest.HTTPMethod = result.method
    
    var encoding = Alamofire.ParameterEncoding.JSON
    if result.method == "GET" {
      encoding = Alamofire.ParameterEncoding.URL
    }
    
    // Add API key to params
    var mergedParams = result.params ?? [String: AnyObject]()
    mergedParams["api_key"] = Credentials.sharedInstance.apiKey
    
    return encoding.encode(baseUrlRequest, parameters: mergedParams).0
  }
}

// MARK: List type of movie
enum ListType: String {
  case Popular = "popular"
  case MostRated = "top_rated"
}

// MARK: List type of segment in Home screen
enum SegmentType: Int {
  case Popular = 0
  case MostRated = 1
  case Favorite = 2
}

// MARK: Login mode
enum LoginMode {
  case PrepareLogin
  case SignIn
  case SignUp
  case ForgotPassword
}

// MARK: Constants in LoginViewController
let defaultTableViewCellHeight: CGFloat = 44
let topConstraintWithKeyboard: CGFloat = 10
let topConstraintWithKeyboardiPad: CGFloat = 30
let topConstraintWithoutKeyboard: CGFloat = 86
let bottomConstraintWithoutKeyboard: CGFloat = 90

// MARK: Message constants
let networkErrorTitle = "Network Error"
let networkErrorMessage = "Please make sure that you have network connectivity and try again."
let noFavoriteMessage = "You haven't liked any movie yet  ☹"
