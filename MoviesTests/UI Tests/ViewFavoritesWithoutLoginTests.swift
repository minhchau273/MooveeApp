//
//  ViewFavoritesWithoutLoginTests.swift
//  Movies
//
//  Created by EastAgile16 on 11/25/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import Parse
import OHHTTPStubs

@testable import Movies

class ViewFavoritesWithoutLoginTests: AuthenticationTestCase {
  
  override func beforeEach() {
    super.beforeEach()
    OHHTTPStubs.stubHomePage()
  }
  
  override func afterEach() {
    super.afterEach()
    OHHTTPStubs.removeAllStubs()
  }
  
  func testViewFavoritesWithoutLogin() {
    tester.tapSkipInPrepareLogin()
    tester.tapFavoriteWithoutLogin()
  }
  
  func testLikeMovieWithoutLogin() {
    tester.tapSkipInPrepareLogin()
    tester.tapInsideOutTitle()
    tester.tapLikeButton()
  }
  
}

// MARK: - Test Details

private extension KIFUITestActor {
  
  // MARK: Test view favorites without login
  func tapSkipInPrepareLogin() {
    isChangedToSignInMode = false
    tapViewWithAccessibilityLabel("OR SKIP ⇥")
    waitForViewWithAccessibilityLabel("Popular")
  }
  
  func tapFavoriteWithoutLogin() {
    tapViewWithAccessibilityLabel("My Favorites")
    waitForViewWithAccessibilityLabel(noFavoriteMessage)
  }
  
  // MARK: Test like movie without login
  func tapInsideOutTitle() {
    OHHTTPStubs.stubFetchMovieDetailsRequest(insideOutId)
    OHHTTPStubs.stubFetchTrailersRequest(insideOutId)
    tapViewWithAccessibilityLabel("INSIDE OUT (2015)")
    waitForViewWithAccessibilityLabel("INSIDE OUT")
  }
  
  func tapLikeButton() {
    tapViewWithAccessibilityLabel("Not Like Button")
    waitForViewWithAccessibilityLabel("Please sign in to save this movie to your favorites!")
    tapViewWithAccessibilityLabel("OK")
  }
  
}