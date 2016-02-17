//
//  ViewDetailFeatureTests.swift
//  Movies
//
//  Created by EastAgile16 on 11/4/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import KIF
import OHHTTPStubs

class ViewDetailFeatureTests: MoviesTestCase {
  
  override func beforeAll() {
    super.beforeAll()
    tester.loginIfNeeded()
  }
  
  // Test movie has trailers, show trailer's title
  func testMovieHasTrailers() {
    tester.tapInsideOutTitle()
    tester.waitForInsideOutTrailer()
  }
  
  // Test movie has no trailer, show "No trailer available" label
  func testMovieHasNoTrailer() {
    tester.tapMostRated()
    tester.tapBandOfBrothersTitle()
    tester.waitForBandOfBrothersTrailer()
  }
  
  // Test movie has reviews, show review's author
  func testMovieHasReviews() {
    tester.tapInsideOutTitle()
    tester.tapInsideOutReviewsTab()
  }
  
  // Test movie has review, show "No review available" label
  func testMovieHasNoReview() {
    tester.tapMostRated()
    tester.tapBandOfBrothersTitle()
    tester.tapBandOfBrothersReviewsTab()
  }
  
  // Test tap "Read more" on each review, show "Read less"
  // Tap "Read less", show "Read more"
  func testReadMore() {
    tester.tapInsideOutTitle()
    tester.tapInsideOutReviewsTab()
    tester.tapReadMore()
    tester.tapReadLess()
  }
  
  func testSavePoster() {
    tester.tapInsideOutTitle()
    tester.longPressOnPoster()
    tester.tapYesToSavePoster()
    tester.tapOKToCloseAlert()
  }
  
  func testLikeAndUnlikeMovie() {
    // Test like movie
    tester.tapInsideOutTitle()
    tester.tapLikeButtonInsideOut()
    tester.tapBackButton()
    tester.tapFavoriteToViewNewLikedMovie()
    
    // Test unlike movie
    tester.tapUnlikeButtonInsideOut()
  }

  
}

// MARK: - Test Details
private extension KIFUITestActor {
  
  // MARK: Test movie has trailers
  func tapInsideOutTitle() {
    OHHTTPStubs.stubFetchMovieDetailsRequest(insideOutId)
    OHHTTPStubs.stubFetchTrailersRequest(insideOutId)
    tapViewWithAccessibilityLabel("INSIDE OUT (2015)")
    waitForViewWithAccessibilityLabel("INSIDE OUT")
  }
  
  func waitForInsideOutTrailer() {
    waitForViewWithAccessibilityLabel("Inside Out Trailer 2")
  }
  
  // MARK: Test movie has no trailers
  func tapBandOfBrothersTitle() {
    OHHTTPStubs.stubFetchMovieDetailsRequest(bandOfBrothersId)
    OHHTTPStubs.stubFetchTrailersRequest(bandOfBrothersId)
    tapViewWithAccessibilityLabel("BAND OF BROTHERS (2001)")
    waitForViewWithAccessibilityLabel("BAND OF BROTHERS")
  }
  
  func waitForBandOfBrothersTrailer() {
    waitForViewWithAccessibilityLabel("No trailer available")
  }
  
  // MARK: Test movie has reviews
  func tapInsideOutReviewsTab() {
    OHHTTPStubs.stubFetchReviewsRequest(insideOutId, page: 1)
    tapViewWithAccessibilityLabel("Reviews")
    waitForCellAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), inTableViewWithAccessibilityIdentifier: "reviewsTableView")
  }
  
  // MARK: Test movie has no review
  func tapBandOfBrothersReviewsTab() {
    OHHTTPStubs.stubFetchTrailersRequest(bandOfBrothersId)
    OHHTTPStubs.stubFetchReviewsRequest(bandOfBrothersId, page: 1)
    tapViewWithAccessibilityLabel("Reviews")
    waitForViewWithAccessibilityLabel("No review available")
  }
  
  // MARK: Test read more each review
  func tapReadMore() {
    tapViewWithAccessibilityLabel("Read more-Andres Gomez")
    waitForViewWithAccessibilityLabel("Read less-Andres Gomez")
  }
  
  func tapReadLess() {
    tapViewWithAccessibilityLabel("Read less-Andres Gomez")
    waitForViewWithAccessibilityLabel("Read more-Andres Gomez")
  }
  
  // MARK: Test like movie Inside Out
  func tapLikeButtonInsideOut() {
    tapViewWithAccessibilityLabel("Not Like Button")
    waitForViewWithAccessibilityLabel("Liked Button")
  }
  
  func tapBackButton() {
    tapViewWithAccessibilityLabel("Back")
    waitForViewWithAccessibilityLabel("Popular")
  }
  
  func tapFavoriteToViewNewLikedMovie() {
    tapViewWithAccessibilityLabel("My Favorites")
    tapViewWithAccessibilityLabel("INSIDE OUT (2015)")
  }
  
  // MARK: Test save poster to Photos
  func longPressOnPoster() {
    longPressViewWithAccessibilityLabel("Detail-Poster", duration: 2)
    waitForViewWithAccessibilityLabel("Save Poster")
  }
  
  func tapYesToSavePoster() {
    tapViewWithAccessibilityLabel("Yes")
    waitForViewWithAccessibilityLabel("Successfully")
  }
  
  func tapOKToCloseAlert() {
    tapViewWithAccessibilityLabel("OK")
    waitForViewWithAccessibilityLabel("INSIDE OUT")
  }
  
  // MARK: Test unlike movie Inside Out
  func tapUnlikeButtonInsideOut() {
    tapViewWithAccessibilityLabel("Liked Button")
    waitForViewWithAccessibilityLabel("Not Like Button")
  }
  
}
