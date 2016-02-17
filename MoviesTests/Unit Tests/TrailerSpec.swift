//
//  TrailerSpec.swift
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

class TrailerSpec: MoviesSpec {
  override func spec() {
    super.spec()
    
    var movie: Movie!
    var trailer: Trailer!
    var duplicatedTrailer: Trailer!
    var trailerObject: PFObject!
    let json = MoviesTests.createTrailerJSON()
    var trailers: [Trailer]!
    
    beforeEach {
      movie = MoviesTests.createMovie(isFull: false)
    }
    
    describe("#init") {
      beforeEach {
        trailer = Trailer(json: json, movie: movie)
      }
      
      it("creates Inside Out's trailer") {
        self.expectTrailer(trailer)
      }
    }
    
    describe(".trailersWithArray") {
      beforeEach {
        trailers = Trailer.trailersWithArray([json, json], movie: movie)
      }
      
      it("creates list of trailers with 2 trailers") {
        expect(trailers.count).to(equal(2))
        for trailer in trailers {
          expect(trailer.key).to(equal(trailerKey))
        }
      }
    }
    
    describe("#duplicateWithMovie") {
      beforeEach {
        trailer = Trailer(json: json, movie: movie)
        duplicatedTrailer = trailer.duplicateWithMovie(movie)
      }
      
      it("duplicates Inside Out's trailer") {
        self.expectTrailer(duplicatedTrailer)
      }
    }
    
    describe("#createPFObject") {
      beforeEach {
        trailer = Trailer(json: json, movie: movie)
        trailerObject = trailer.createPFObject()
      }
      
      it("creates Inside Out's trailer Parse object") {
        self.expectTrailerObject(trailerObject)
      }
    }
  }
}

// MARK: - Test Details
extension TrailerSpec {
  func expectTrailer(trailer: Trailer) {
    expect(trailer.movie!.id).to(equal(insideOutId))
    expect(trailer.name).to(equal(trailerName))
    expect(trailer.key).to(equal(trailerKey))
    expect(trailer.youTubeUrl).to(equal("youtube://\(trailerKey)"))
    expect(trailer.safariUrl).to(equal("https://youtu.be/\(trailerKey)"))
    expect(trailer.thumbnailUrl).to(equal("http://img.youtube.com/vi/\(trailerKey)/0.jpg"))
  }
  
  func expectTrailerObject(object: PFObject) {
    expect(object["name"] as? String).to(equal(trailerName))
    expect(object["key"] as? String).to(equal(trailerKey))
  }
}
