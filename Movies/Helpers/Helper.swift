//
//  Helper.swift
//  Movies
//
//  Created by EastAgile16 on 11/6/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation
import Reachability
import RealmSwift

class Helper {
  static func isTestMode() -> Bool {
    #if DEBUG
      if env("XCInjectBundle") != nil {
        return true
      }
    #endif
    return false
  }
  
  static func env(key: String) -> String? {
    let dict = NSProcessInfo.processInfo().environment
    return dict[key]
  }
  
  static func hasConnectivity() -> Bool {
    let reachability = Reachability.reachabilityForInternetConnection()
    let networkStatus: Int = reachability.currentReachabilityStatus().hashValue
    return networkStatus != 0
  }
  
  static func setDefaultRealmForUser(email: String) {
    var config = Realm.Configuration()
    
    // Use the default directory, but replace the filename with the username
    config.path = NSURL.fileURLWithPath(config.path!)
      .URLByDeletingLastPathComponent?
      .URLByAppendingPathComponent("\(email).realm")
      .path
    
    // Set this as the configuration used for the default Realm
    Realm.Configuration.defaultConfiguration = config
  }
  
}

// MARK: - Save poster to documents directory

extension Helper {
  
  static func savePosterToDocumentsDirectory(movie: Movie) -> String {
    var posterLocalPath = ""
    let imageUrl = NSURL(string: movie.originalPoster)
    if let imageUrl = imageUrl,
      imageData = NSData(contentsOfURL: imageUrl),
      image = UIImage(data: imageData) {
        let localPath = getFileInDocumentsDirectory("\(movie.id).jpg")
        if saveImage(image, path: localPath) {
          posterLocalPath = localPath
        }
    }
    return posterLocalPath
  }
  
  private static func saveImage(image: UIImage, path: String) -> Bool {
    if let jpgImageData = UIImageJPEGRepresentation(image, 1.0) {
      return jpgImageData.writeToFile(path, atomically: true)
    }
    return false
  }
  
  // Get the documents Directory
  private static func getDocumentsDirectory() -> String {
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    return documentsFolderPath
  }
  
  // Get path for a file in the directory
  private static func getFileInDocumentsDirectory(filename: String) -> String {
    return (getDocumentsDirectory() as NSString).stringByAppendingPathComponent(filename)
  }
  
}
