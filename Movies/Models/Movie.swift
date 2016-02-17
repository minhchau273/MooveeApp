//
//  Movie.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Parse
import RealmSwift
import SwiftyJSON

class Movie: Object {
  dynamic var id = 0
  dynamic var title = ""
  dynamic var lowResolutionPoster = ""
  dynamic var thumbnailPoster = ""
  dynamic var originalPoster = ""
  dynamic var posterLocalPath = ""
  dynamic var releaseDate: NSDate?
  dynamic var overview = ""
  dynamic var voteAverage: Double = 0
  dynamic var totalReviewPages = 0
  dynamic var currentReviewPage = 0
  dynamic var isLiked = false
  
  let trailers = List<Trailer>()
  let reviews = List<Review>()
  
  convenience init(json: JSON, isFull: Bool) {
    self.init()
    
    id = json["id"].intValue
    title = json["title"].stringValue
    
    if let posterPath = json["poster_path"].string {
      originalPoster = MovieClient.baseImageUrl + "original" + posterPath
      thumbnailPoster = MovieClient.baseImageUrl + "w300" + posterPath
      lowResolutionPoster = MovieClient.baseImageUrl + "w154" + posterPath
    }
    
    if let releaseDateString = json["release_date"].string {
      releaseDate = DateFormatter.yyyy_MM_dd.dateFromString(releaseDateString)
    }
    
    if isFull {
      overview = json["overview"].stringValue
      voteAverage = json["vote_average"].doubleValue
    }
  }
  
  convenience init(object: PFObject) {
    self.init()
    
    id = (object["id"] as? Int) ?? 0
    title = (object["title"] as? String) ?? ""
    lowResolutionPoster = (object["lowResolutionPoster"] as? String)  ?? ""
    thumbnailPoster = (object["thumbnailPoster"] as? String)  ?? ""
    originalPoster = (object["originalPoster"] as? String)  ?? ""
    releaseDate = object["releaseDate"] as? NSDate
    overview = (object["overview"] as? String)  ?? ""
    voteAverage = (object["voteAverage"] as? Double)  ?? 0.0
    totalReviewPages = (object["totalReviewPages"] as? Int)  ?? 0
    currentReviewPage = (object["currentReviewPage"] as? Int)  ?? 0
    isLiked = (object["isLiked"] as? Bool)  ?? true
  }
  
  static func moviesWithArray(array: [JSON]) -> [Movie] {
    var movies = [Movie]()
    
    for json in array {
      movies.append(Movie(json: json, isFull: false))
    }
    
    return movies
  }
  
  func duplicate() -> Movie {
    let newMovie = Movie()
    newMovie.id = id
    newMovie.title = title
    newMovie.lowResolutionPoster = lowResolutionPoster
    newMovie.thumbnailPoster = thumbnailPoster
    newMovie.originalPoster = originalPoster
    newMovie.posterLocalPath = posterLocalPath
    newMovie.releaseDate = releaseDate
    newMovie.overview = overview
    newMovie.voteAverage = voteAverage
    newMovie.totalReviewPages = totalReviewPages
    newMovie.currentReviewPage = currentReviewPage
    newMovie.isLiked = isLiked
    
    for trailer in trailers {
      newMovie.trailers.append(trailer.duplicateWithMovie(newMovie))
    }
    for review in reviews {
      newMovie.reviews.append(review.duplicateWithMovie(newMovie))
    }
    
    return newMovie
  }
}

// MARK: - Computed properties

extension Movie {
  var releaseYear: String {
    return releaseDate != nil ? DateFormatter.yyyy.stringFromDate(releaseDate!) : ""
  }
  
  var releaseDateString: String {
    return releaseDate != nil ? DateFormatter.yyyy_MM_dd.stringFromDate(releaseDate!) : ""
  }
  
  var releaseDateFormat: String {
    return releaseDate != nil ? DateFormatter.MMMM_yyyy.stringFromDate(releaseDate!) : ""
  }
}

// MARK: - RealmObject

extension Movie {
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  func save(completion: (error: NSError?) -> ()) {
    posterLocalPath = Helper.savePosterToDocumentsDirectory(self)
    
    saveToParse { (error) -> () in
      if error != nil {
        completion(error: error)
      } else {
        self.saveToRealm()
        completion(error: nil)
      }
    }
  }
  
  func saveToRealm() {
    let realm = try! Realm()
    try! realm.write {
      realm.add(self, update: true)
    }
  }
  
  func delete() {
    getMovieFromParse { (movie) -> () in
      if let movie = movie {
        self.deleteMovieDetailInParse(movie)
        movie.deleteInBackground()
        let realm = try! Realm()
        try! realm.write {
          for trailer in self.trailers {
            realm.delete(trailer)
          }
          for review in self.reviews {
            realm.delete(review)
          }
          realm.delete(self)
        }
      }
    }
  }
  
  static var allFavorites: [Movie] {
    return Array(try! Realm().objects(Movie))
  }
  
  static func getFavoriteMovieFromId(id: Int) -> Movie? {
    return try! Realm().objectForPrimaryKey(Movie.self, key: id)
  }
  
}

// MARK: - Parse

extension Movie {
  
  func getMovieFromParse(completion: (movie: PFObject?) -> ()) {
    let query = PFQuery(className: "Movie")
    query.whereKey("id", equalTo: id)
    query.findObjectsInBackgroundWithBlock {
      (objects: [PFObject]?, error: NSError?) -> Void in
      
      if error == nil {
        if let objects = objects where objects.count > 0 {
          completion(movie: objects[0])
        } else {
          completion(movie: nil)
        }
      } else {
        completion(movie: nil)
      }
    }
  }
  
  func deleteMovieDetailInParse(movie: PFObject) {
    deleteObjectInParse(movie: movie, className: "Trailer")
    deleteObjectInParse(movie: movie, className: "Review")
  }
  
  func deleteObjectInParse(movie movie: PFObject, className: String) {
    let key = className == "Trailer" ? "trailerList" : "reviewList"
    if let objectList = movie.objectForKey(key) as? [PFObject] {
      for item in objectList {
        let query = PFQuery(className: className)
        if let id = item.objectId {
          query.whereKey("objectId", equalTo: id)
          query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
              if let objects = objects {
                PFObject.deleteAllInBackground(objects)
              }
            }
          }
        }
      }
    }
  }
  
  func saveToParse(completion: (error: NSError?) -> ()) {
    let movie = PFObject(className: "Movie")
    movie["id"] = id
    movie["title"] = title
    movie["lowResolutionPoster"] = lowResolutionPoster
    movie["thumbnailPoster"] = thumbnailPoster
    movie["originalPoster"] = originalPoster
    movie["releaseDate"] = releaseDate
    movie["overview"] = overview
    movie["voteAverage"] = voteAverage
    movie["totalReviewPages"] = totalReviewPages
    movie["currentReviewPage"] = currentReviewPage
    movie["isLiked"] = isLiked
    movie["parent"] = PFUser.currentUser()
    
    let trailerList = trailers.map({ return $0.createPFObject() })
    movie["trailerList"] = trailerList
    
    let reviewList = reviews.map({ return $0.createPFObject() })
    movie["reviewList"] = reviewList
    
    movie.saveInBackgroundWithBlock { (success, error) -> Void in
      completion(error: error)
    }
  }
  
}
