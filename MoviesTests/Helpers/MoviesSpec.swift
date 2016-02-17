//
//  MoviesSpec.swift
//  Movies
//
//  Created by EastAgile16 on 10/29/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs

class MoviesSpec: QuickSpec {
  override func spec() {
    beforeEach {
      OHHTTPStubs.stubFetchBaseImageUrlRequest()
    }
    
    afterEach {
      OHHTTPStubs.removeAllStubs()
    }
  }
}
