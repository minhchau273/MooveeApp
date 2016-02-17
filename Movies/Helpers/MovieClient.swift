//
//  MovieClient.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MovieClient: NSObject {
  static var baseImageUrl = ""
  
  static func requestAPI(urlRequest: URLRequestConvertible, completion : (json : JSON?, error : NSError?) -> Void) {
    Alamofire.request(urlRequest).responseJSON { response in
      if let error = response.result.error {
        completion(json: nil, error: error)
      } else {
        if let data = response.result.value {
          let json = JSON(data)
          if let errorCode = json["status_code"].int {
            completion(json: nil, error: NSError(domain: apiBaseUrl, code: errorCode, userInfo: nil))
          } else {
            completion(json: json, error: nil)
          }
        }
      }
    }
  }
  
  static func getMovies(type: ListType, page: Int, completion: (movies: [Movie]?, error: NSError?) -> ()) {
    var params = [String: AnyObject]()
    params["page"] = page
    
    requestAPI(Router.ListMovies(type: type.rawValue, params: params)) { (json, error) -> Void in
      if let json = json {
        if let results = json.dictionaryValue["results"], let resultsArray = results.array {
          let movies = Movie.moviesWithArray(resultsArray)
          completion(movies: movies, error: nil)
        }
      } else {
        completion(movies: nil, error: error)
        print("Error when getting movies")
      }
    }
  }
  
  static func getMovieDetail(id: Int, completion: (movie: Movie?, error: NSError?) -> ()) {
    requestAPI(Router.MovieDetail(id: id)) { (json, error) -> Void in
      if let json = json {
        let movie = Movie(json: json, isFull: true)
        if movie.id != 0 {
          completion(movie: movie, error: nil)
        } else {
          completion(movie: nil, error: error)
        }
      } else {
        completion(movie: nil, error: error)
        print("Error when getting movie's details")
      }
    }
  }
  
  static func getTrailers(movie: Movie, completion: (trailers: [Trailer]?, error: NSError?) -> ()) {
    requestAPI(Router.Trailers(id: movie.id)) { (json, error) -> Void in
      if let json = json {
        if let results = json.dictionaryValue["results"], let resultsArray = results.array {
          let trailers = Trailer.trailersWithArray(resultsArray, movie: movie)
          completion(trailers: trailers, error: nil)
        }
      } else {
        completion(trailers: nil, error: error)
        print("Error when getting trailers")
      }
    }
  }
  
  static func getMovieWithTrailers(id: Int, completion: (movie: Movie?, error: NSError?) -> ()) {
    getMovieDetail(id) { (movie, error) -> () in
      if let movie = movie {
        getTrailers(movie, completion: { (trailers, error) -> () in
          if let trailers = trailers {
            for trailer in trailers {
              movie.trailers.append(trailer)
            }
            completion(movie: movie, error: nil)
          } else {
            completion(movie: nil, error: error)
          }
        })
      } else {
        completion(movie: nil, error: error)
      }
    }
  }
  
  static func getReviews(movie: Movie, page: Int, completion: (reviews: [Review]?, totalPages: Int, error: NSError?) -> ()) {
    var params = [String: AnyObject]()
    params["page"] = page
    
    requestAPI(Router.Reviews(id: movie.id, params: params)) { (json, error) -> Void in
      if let json = json {
        if let results = json.dictionaryValue["results"], array = results.array {
          let reviews = Review.reviewsWithArray(array, movie: movie)
          let totalPages = json["total_pages"].intValue
          completion(reviews: reviews, totalPages: totalPages, error: nil)
        }
      } else {
        completion(reviews: nil, totalPages: 0, error: error)
        print("Error when getting reviews")
      }
    }
  }
  
  static func getBaseImageUrl(completion: (baseUrl: String?, error: NSError?) -> ()) {
    requestAPI(Router.BaseImageUrl) { (json, error) -> Void in
      if let json = json {
        if let baseUrl = json["images"]["base_url"].string where !baseUrl.isEmpty {
          completion(baseUrl: baseUrl, error: nil)
        }
      } else {
        completion(baseUrl: nil, error: error)
        print("Error when getting base image url")
      }
    }
  }
}
