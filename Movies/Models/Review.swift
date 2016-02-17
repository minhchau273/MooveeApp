//
//  Review.swift
//  Movies
//
//  Created by EastAgile16 on 11/2/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Parse
import RealmSwift
import SwiftyJSON

class Review: Object {
  dynamic var id = ""
  dynamic var author = ""
  dynamic var content = ""
  dynamic var movie: Movie?
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  convenience init(json: JSON, movie: Movie) {
    self.init()
    id = json["id"].stringValue
    author = json["author"].stringValue
    content = json["content"].stringValue
    self.movie = movie
  }
  
  convenience init(object: PFObject) {
    self.init()
    id = (object["id"] as? String)  ?? ""
    author = (object["author"] as? String)  ?? ""
    content = (object["content"] as? String)  ?? ""
  }
  
  static func reviewsWithArray(array: [JSON], movie: Movie) -> [Review] {
    var reviews = [Review]()
    
    for json in array {
      reviews.append(Review(json: json, movie: movie))
    }
    
    return reviews
  }
  
  func duplicateWithMovie(newMovie: Movie) -> Review {
    let newReview = Review()
    newReview.id = id
    newReview.author = author
    newReview.content = content
    newReview.movie = newMovie
    return newReview
  }
  
  func createPFObject() -> PFObject {
    let review = PFObject(className: "Review")
    review["id"] = id
    review["author"] = author
    review["content"] = content
    return review
  }
}
