//
//  ReviewSpec.swift
//  Movies
//
//  Created by EastAgile16 on 11/3/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftyJSON
import Parse

@testable import Movies

class ReviewSpec: MoviesSpec {
  override func spec() {
    super.spec()
    
    var movie: Movie!
    var review: Review!
    var duplicatedReview: Review!
    var reviewObject: PFObject!
    let json = MoviesTests.createReviewJSON()
    var reviews: [Review]!
    
    beforeEach {
      movie = MoviesTests.createMovie(isFull: false)
    }
    
    describe("#init") {
      beforeEach {
        review = Review(json: json, movie: movie)
      }
      
      it("creates Inside Out's review") {
        self.expectReview(review)
      }
    }
    
    describe(".reviewsWithArray") {
      beforeEach {
        reviews = Review.reviewsWithArray([json, json], movie: movie)
      }
      
      it("creates list of reviews with 2 reviews") {
        expect(reviews.count).to(equal(2))
        for review in reviews {
          expect(review.author).to(equal("Fatota"))
        }
      }
    }
    
    describe("#duplicateWithMovie") {
      beforeEach {
        review = Review(json: json, movie: movie)
        duplicatedReview = review.duplicateWithMovie(movie)
      }
      
      it("duplicates Inside Out's review") {
        self.expectReview(duplicatedReview)
      }
    }
    
    describe("#createPFObject") {
      beforeEach {
        review = Review(json: json, movie: movie)
        reviewObject = review.createPFObject()
      }
      
      it("creates Inside Out's review Parse object") {
        self.expectReviewObject(reviewObject)
      }
    }
  }
}

// MARK: - Test Details
extension ReviewSpec {
  func expectReview(review: Review) {
    expect(review.movie!.id).to(equal(insideOutId))
    expect(review.id).to(equal(reviewId))
    expect(review.author).to(equal(reviewAuthor))
    expect(review.content).to(equal(reviewContent))
  }
  
  func expectReviewObject(object: PFObject) {
    expect(object["id"] as? String).to(equal(reviewId))
    expect(object["author"] as? String).to(equal(reviewAuthor))
    expect(object["content"] as? String).to(equal(reviewContent))
  }
}
