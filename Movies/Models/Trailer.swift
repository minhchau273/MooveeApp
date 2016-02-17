//
//  Trailer.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Parse
import RealmSwift
import SwiftyJSON

class Trailer: Object {
  dynamic var name = ""
  dynamic var key = ""
  dynamic var movie: Movie?
  
  override static func primaryKey() -> String? {
    return "key"
  }
  
  convenience init(json: JSON, movie: Movie) {
    self.init()
    name = json["name"].stringValue
    key = json["key"].stringValue
    self.movie = movie
  }
  
  convenience init(object: PFObject) {
    self.init()
    name = (object["name"] as? String)  ?? ""
    key = (object["key"] as? String)  ?? ""
  }
  
  static func trailersWithArray(array: [JSON], movie: Movie) -> [Trailer] {
    var trailers = [Trailer]()
    
    for json in array {
      trailers.append(Trailer(json: json, movie: movie))
    }
    
    return trailers
  }
  
  func duplicateWithMovie(newMovie: Movie) -> Trailer {
    let newTrailer = Trailer()
    newTrailer.name = name
    newTrailer.key = key
    newTrailer.movie = newMovie
    return newTrailer
  }
  
  func createPFObject() -> PFObject {
    let trailer = PFObject(className: "Trailer")
    trailer["name"] = name
    trailer["key"] = key
    return trailer
  }
  
}

// MARK: - Computed properties
extension Trailer {
  var youTubeUrl: String {
    return "youtube://" + key
  }
  
  var safariUrl: String {
    return "https://youtu.be/" + key
  }
  
  var thumbnailUrl: String {
    return "http://img.youtube.com/vi/\(key)/0.jpg"
  }
}
