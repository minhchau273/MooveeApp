//
//  HomeScreenTests.swift
//  Movies
//
//  Created by EastAgile16 on 11/4/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import OHHTTPStubs

@testable import Movies

class HomeScreenTests: MoviesTestCase {
  
  override func beforeAll() {
    super.beforeAll()
    tester.loginIfNeeded()
  }
  
  // Test load Popular movies, show "Inside Out" movie
  func testLoadPopularMovies() {
    tester.waitForViewWithAccessibilityLabel("INSIDE OUT (2015)")
  }
  
  // Test change to Most Rated tab, show "Band of Brothers" movie
  func testChangeToMostRatedTab() {
    tester.tapMostRated()
  }
  
  // Test change to My Favorites tab, show "Minions" movie
  func testChangeToFavoritesTab() {
    tester.tapFavorite()
  }
  
}

// MARK: - Test Details
extension KIFUITestActor {
  func tapMostRated() {
    OHHTTPStubs.stubFetchMostRatedMoviesRequest(page: 1)
    tapViewWithAccessibilityLabel("Most Rated")
    waitForViewWithAccessibilityLabel("BAND OF BROTHERS (2001)")
  }
  
  func tapFavorite() {
    tapViewWithAccessibilityLabel("My Favorites")
    waitForViewWithAccessibilityLabel("MINIONS (2015)")
  }
}
