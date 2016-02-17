//
//  Constants.swift
//  Movies
//
//  Created by EastAgile16 on 11/16/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation
@testable import Movies

// MARK: Constants for sample user
let sampleSignInUserEmail = "demo@sample.com"
let sampleSignUpUserEmail = "demo0@sample.com"
let sampleInvalidEmail = "demo@sample"
let sampleUserPassword = "zxc"
let sampleWrongUserPassword = "zx"

// MARK: Constants for movie
let insideOutId = 150540
let bandOfBrothersId = 331214
let movieTitle = "Inside Out"
let movieOverview = "Growing up can be a bumpy road, and it's no exception for Riley"
let movieReleaseDateString = "2015-06-19"
let movieReleaseYear = "2015"
let movieReleaseDateFormat = "June 2015"
let movieVoteAverage = 8.2
let moviePosterPath = "/aAmfIX3TT40zUHGcCKrlOZRKC7u.jpg"
let movieLowResolutionPoster = "\(MovieClient.baseImageUrl)w154\(moviePosterPath)"
let movieThumbnailPoster = "\(MovieClient.baseImageUrl)w300\(moviePosterPath)"
let movieOriginalPoster = "\(MovieClient.baseImageUrl)original\(moviePosterPath)"
let movieReleaseDate = DateFormatter.yyyy_MM_dd.dateFromString("2015-06-19")
let movieTotalReviewPages = 0
let movieCurrentReviewPage = 0
let movieDefautlLiked = false


// MARK: Constants for trailer
let trailerName = "Inside Out Trailer 2"
let trailerKey = "_MC3XuMvsDI"

// MARK: Constants for review
let reviewId = "5611c3d99251417899002fcd"
let reviewAuthor = "Fatota"
let reviewContent = "This is the most incredible movie I've ever seen :)"