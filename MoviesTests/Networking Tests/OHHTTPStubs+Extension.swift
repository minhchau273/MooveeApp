//
//  OHHTTPStubs+Extension.swift
//  Movies
//
//  Created by EastAgile16 on 10/28/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import OHHTTPStubs
@testable import Movies

extension OHHTTPStubs {
  
  private class func stubFetchRequest(requestUrl: String, fixture: String) {
    OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
      if let url = request.URL?.absoluteString {
        return url == requestUrl
      }
      return false
      }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
        let fixture = OHPathForFile(fixture, MoviesTests.self)
        return OHHTTPStubsResponse(fileAtPath: fixture!, statusCode: 200, headers: ["Content-Type":"application/json"])
    })
  }
  
  class func stubFetchPopularMoviesRequest(page page: Int) {
    return stubFetchRequest(Router.ListMovies(type: ListType.Popular.rawValue, params: ["page": page]).URLRequest.URLString, fixture: "popular_response.json")
  }
  
  class func stubFetchMostRatedMoviesRequest(page page: Int) {
    return stubFetchRequest(Router.ListMovies(type: ListType.MostRated.rawValue, params: ["page": page]).URLRequest.URLString, fixture: "most_rated_response.json")
  }
  
  class func stubFetchTrailersRequest(id: Int) {
    return stubFetchRequest(Router.Trailers(id: id).URLRequest.URLString, fixture: "trailers_\(id)_response.json")
  }
  
  class func stubFetchMovieDetailsRequest(id: Int) {
    return stubFetchRequest(Router.MovieDetail(id: id).URLRequest.URLString, fixture: "movie_\(id)_response.json")
  }
  
  class func stubFetchReviewsRequest(id: Int, page: Int) {
    return stubFetchRequest(Router.Reviews(id: id, params: ["page": page]).URLRequest.URLString, fixture: "reviews_\(id)_response.json")
  }
  
  class func stubFetchBaseImageUrlRequest() {
    return stubFetchRequest(Router.BaseImageUrl.URLRequest.URLString, fixture: "configuration_response.json")
  }
  
  class func stubErrorRequestWithErrorCode(errorCode: Int32) {
    OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.absoluteString.contains(apiBaseUrl) }) { _ in
      let fixture = OHPathForFile("error_34_response.json", MoviesTests.self)
      return OHHTTPStubsResponse(fileAtPath: fixture!,
        statusCode: errorCode, headers: ["Content-Type":"application/json"])
    }
  }
  
  class func stubHomePage() {
    OHHTTPStubs.stubFetchBaseImageUrlRequest()
    OHHTTPStubs.stubFetchPopularMoviesRequest(page: 1)
  }
  
}

extension String {
  func contains(find: String) -> Bool {
    return self.rangeOfString(find) != nil
  }
}
