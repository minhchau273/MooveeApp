//
//  MovieSpec.swift
//  Movies
//
//  Created by EastAgile16 on 10/27/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import Parse

@testable import Movies

class MovieSpec: MoviesSpec {
  override func spec() {
    super.spec()
    
    var movie: Movie!
    var duplicatedMovie: Movie!
    let json = MoviesTests.createMovieJSON()
    let movieObject = MoviesTests.createMoviePFObject()
    var movies: [Movie]!
    
    describe("#init") {
      context("new movie with short detail") {
        beforeEach {
          movie = Movie(json: json, isFull: false)
        }
        
        it("creates Inside Out movie with short detail") {
          self.expectShortDetailMovie(movie)
        }
      }
      
      context("new movie with full detail") {
        beforeEach {
          movie = Movie(json: json, isFull: true)
        }
        
        it("creates Inside Out movie with full detail") {
          self.expectFullDetailMovie(movie)
        }
      }
      
      context("new movie from Parse object") {
        beforeEach {
          movie = Movie(object: movieObject)
        }
        
        it("creates Inside Out movie with full detail from Parse object") {
          self.expectFullDetailMovie(movie)
        }
      }
    }
    
    describe(".moviesWithArray") {
      beforeEach {
        movies = Movie.moviesWithArray([json, json])
      }
      
      it("creates list of movies with 2 movies") {
        expect(movies.count).to(equal(2))
        for movie in movies {
          expect(movie.title).to(equal(movieTitle))
        }
      }
    }
    
    describe("#duplicate") {
      beforeEach {
        movie = MoviesTests.createMovieWithTrailersAndReviews()
        duplicatedMovie = movie.duplicate()
      }
      
      it("duplicates Inside Out movie") {
        self.expectMovieWithTrailersAndReviews(duplicatedMovie)
      }
    }
    
    describe("#saveToRealm") {
      var movieFromRealm: Movie!
      
      beforeEach {
        Helper.setDefaultRealmForUser("test")
        movie = MoviesTests.createMovieWithTrailersAndReviews()
        movie.saveToRealm()
        movieFromRealm = Movie.getFavoriteMovieFromId(movie.id)
      }
      
      it("saves Inside Out movie to Realm") {
        expect(movieFromRealm.id).to(equal(insideOutId))
      }
    }
    
    describe(".allFavorites") {
      var moviesFromRealm = [Movie]()
      
      beforeEach {
        moviesFromRealm = Movie.allFavorites
      }
      
      it("gets all favorite movies from Realm") {
        expect(moviesFromRealm.count).to(equal(1))
      }
    }
  }
}

// MARK: - Test Details
extension MovieSpec {
  
  func expectShortDetailMovie(movie: Movie) {
    expect(movie.id).to(equal(insideOutId))
    expect(movie.title).to(equal(movieTitle))
    expect(movie.lowResolutionPoster).to(equal(movieLowResolutionPoster))
    expect(movie.thumbnailPoster).to(equal(movieThumbnailPoster))
    expect(movie.originalPoster).to(equal(movieOriginalPoster))
    expect(movie.releaseYear).to(equal(movieReleaseYear))
    expect(movie.releaseDateString).to(equal(movieReleaseDateString))
    expect(movie.releaseDateFormat).to(equal(movieReleaseDateFormat))
    expect(movie.isLiked).to(equal(movieDefautlLiked))
  }
  
  func expectFullDetailMovie(movie: Movie) {
    expectShortDetailMovie(movie)
    expect(movie.overview).to(equal(movieOverview))
    expect(movie.voteAverage).to(equal(movieVoteAverage))
  }
  
  func expectMovieWithTrailersAndReviews(movie: Movie) {
    expectFullDetailMovie(movie)
    expect(movie.trailers.count).to(equal(1))
    expect(movie.reviews.count).to(equal(1))
  }
  
}
  