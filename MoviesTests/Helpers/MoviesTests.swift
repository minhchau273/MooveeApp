//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Parse

@testable import Movies

class MoviesTests {
  static func createMovieJSON() -> JSON {
    var json: JSON = ["id": insideOutId]
    json["overview"] = JSON(movieOverview)
    json["poster_path"] = JSON(moviePosterPath)
    json["release_date"] = JSON(movieReleaseDateString)
    json["title"] = JSON(movieTitle)
    json["vote_average"] = JSON(movieVoteAverage)
    return json
  }
  
  static func createTrailerJSON() -> JSON {
    var json: JSON = ["name": trailerName]
    json["key"] = JSON(trailerKey)
    return json
  }
  
  static func createReviewJSON() -> JSON {
    var json: JSON = ["id": reviewId]
    json["author"] = JSON(reviewAuthor)
    json["content"] = JSON(reviewContent)
    return json
  }
  
  static func createMovie(isFull isFull: Bool) -> Movie {
    let json = createMovieJSON()
    return Movie(json: json, isFull: isFull)
  }
  
  static func createMoviePFObject() -> PFObject {
    let object = PFObject(className: "Movie")
    object["id"] = insideOutId
    object["title"] = movieTitle
    object["lowResolutionPoster"] = movieLowResolutionPoster
    object["thumbnailPoster"] = movieThumbnailPoster
    object["originalPoster"] = movieOriginalPoster
    object["releaseDate"] = movieReleaseDate
    object["overview"] = movieOverview
    object["voteAverage"] = movieVoteAverage
    object["totalReviewPages"] = movieTotalReviewPages
    object["currentReviewPage"] = movieCurrentReviewPage
    object["isLiked"] = false
    return object
  }
  
  static func createTrailerPFObject() -> PFObject {
    let object = PFObject(className: "Trailer")
    object["name"] = trailerName
    object["key"] = trailerKey
    return object
  }
  
  static func createReviewPFObject() -> PFObject {
    let object = PFObject(className: "Review")
    object["id"] = reviewId
    object["author"] = reviewAuthor
    object["content"] = reviewContent
    return object
  }
  
  static func createMovieWithTrailersAndReviews() -> Movie {
    let movie = createMovie(isFull: true)
    movie.trailers.append(Trailer(json: createTrailerJSON(), movie: movie))
    movie.reviews.append(Review(json: createReviewJSON(), movie: movie))
    return movie
  }
}
