//
//  NetworkingTests.swift
//  Movies
//
//  Created by EastAgile16 on 10/28/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs

@testable import Movies

class NetworkingSpec: MoviesSpec {
  override func spec() {
    super.spec()
    
    testMovie()
    testMovieDetails()
    testTrailer()
    testReview()
    testBaseImageUrl()
  }
}

// MARK: - Test Details
extension NetworkingSpec {
  
  func testMovie() {
    describe(".getMovies") {
      var actualReceivedMovies: [Movie]?
      
      context("server returns valid data") {
        beforeEach {
          OHHTTPStubs.stubFetchPopularMoviesRequest(page: 1)
          MovieClient.getMovies(.Popular, page: 1, completion: { (movies, error) -> () in
            actualReceivedMovies = movies
          })
        }
        
        it("gets popular movies") {
          expect(actualReceivedMovies?.count).toEventually(equal(20))
        }
      }
      
      context("server returns errors") {
        var responseError: NSError?
        let expectedErrorCode = 34
        
        beforeEach {
          OHHTTPStubs.stubErrorRequestWithErrorCode(Int32(expectedErrorCode))
          MovieClient.getMovies(.Popular, page: 1, completion: { (movies, error) -> () in
            actualReceivedMovies = movies
            responseError = error
          })
        }
        
        it("gets error when getting popular movies") {
          expect(responseError?.code).toEventually(equal(expectedErrorCode))
          expect(actualReceivedMovies).to(beNil())
        }
      }
    }
  }
  
  func testMovieDetails() {
    describe(".getMovieDetail") {
      var actualReceivedMovie: Movie?
      
      context("server returns valid data") {
        beforeEach {
          let id = insideOutId
          OHHTTPStubs.stubFetchMovieDetailsRequest(id)
          MovieClient.getMovieDetail(id, completion: { (movie, error) -> () in
            actualReceivedMovie = movie
          })
        }
        
        it("gets Inside Out movies") {
          expect(actualReceivedMovie?.title == "Inside Out").toEventually(beTruthy())
        }
      }
      
      context("server returns errors") {
        var responseError: NSError?
        let expectedErrorCode = 34
        
        beforeEach {
          OHHTTPStubs.stubErrorRequestWithErrorCode(Int32(expectedErrorCode))
          
          MovieClient.getMovieDetail(0, completion: { (movie, error) -> () in
            actualReceivedMovie = movie
            responseError = error
          })
        }
        
        it("gets movie's detail with invalid movie") {
          expect(responseError?.code).toEventually(equal(expectedErrorCode))
          expect(actualReceivedMovie).to(beNil())
        }
      }
    }
  }
  
  func testTrailer() {
    describe(".getTrailers") {
      var movie: Movie!
      var actualReceivedTrailers: [Trailer]?
      
      beforeEach {
        movie = MoviesTests.createMovie(isFull: false)
      }
      
      context("server returns valid data") {
        beforeEach {
          OHHTTPStubs.stubFetchTrailersRequest(insideOutId)
          MovieClient.getTrailers(movie, completion: { (trailers, error) -> () in
            actualReceivedTrailers = trailers
          })
        }
        
        it("gets all trailers of a movie") {
          expect(actualReceivedTrailers?.count).toEventually(equal(2))
        }
      }
      
      context("server returns errors") {
        var responseError: NSError?
        let expectedErrorCode = 34
        
        beforeEach {
          OHHTTPStubs.stubErrorRequestWithErrorCode(Int32(expectedErrorCode))
          movie.id = 0
          MovieClient.getTrailers(movie, completion: { (trailers, error) -> () in
            actualReceivedTrailers = trailers
            responseError = error
          })
        }
        
        it("gets trailers with invalid movie") {
          expect(responseError?.code).toEventually(equal(expectedErrorCode))
          expect(actualReceivedTrailers).to(beNil())
        }
      }
    }
  }
  
  func testReview() {
    describe(".getReviews") {
      var movie: Movie!
      var actualReceivedReviews: [Review]?
      var actualTotalPages: Int?
      beforeEach {
        movie = MoviesTests.createMovie(isFull: false)
      }
      
      context("server returns valid data") {
        beforeEach {
          OHHTTPStubs.stubFetchReviewsRequest(insideOutId, page: 1)
          MovieClient.getReviews(movie, page: 1, completion: { (reviews, totalPages, error) -> () in
            actualReceivedReviews = reviews
            actualTotalPages = totalPages
          })
        }
        
        it("gets all reviews of a movie") {
          expect(actualReceivedReviews?.count).toEventually(equal(2))
          expect(actualTotalPages).toEventually(equal(1))
        }
      }
      
      context("server returns errors") {
        var responseError: NSError?
        let expectedErrorCode = 34
        beforeEach {
          OHHTTPStubs.stubErrorRequestWithErrorCode(Int32(expectedErrorCode))
          movie.id = 0
          MovieClient.getReviews(movie, page: 1, completion: { (reviews, totalPages, error) -> () in
            actualReceivedReviews = reviews
            actualTotalPages = totalPages
            responseError = error
          })
        }
        
        it("gets reviews with invalid movie") {
          expect(responseError?.code).toEventually(equal(expectedErrorCode))
          expect(actualReceivedReviews).to(beNil())
          expect(actualTotalPages).toEventually(equal(0))
        }
      }
    }
  }
  
  func testBaseImageUrl() {
    describe(".getBaseImageUrl") {
      var actualReceivedUrl: String?
      
      context("server returns valid data") {
        beforeEach {
          OHHTTPStubs.stubFetchBaseImageUrlRequest()
          MovieClient.getBaseImageUrl({ (baseUrl, error) -> () in
            actualReceivedUrl = baseUrl
          })
        }
        
        it("gets base image url") {
          expect(actualReceivedUrl == "http://image.tmdb.org/t/p/").toEventually(beTruthy())
        }
      }
      
      context("server returns errors") {
        var responseError: NSError?
        let expectedErrorCode = 34
        
        beforeEach {
          OHHTTPStubs.stubErrorRequestWithErrorCode(Int32(expectedErrorCode))
          MovieClient.getBaseImageUrl({ (baseUrl, error) -> () in
            actualReceivedUrl = baseUrl
            responseError = error
          })
        }
        
        it("gets error when getting base image url") {
          expect(responseError?.code).toEventually(equal(expectedErrorCode))
          expect(actualReceivedUrl).to(beNil())
        }
      }
    }
  }
  
}
