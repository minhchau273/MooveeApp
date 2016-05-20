# MovieApp

Movies can help you view movies information. You can keep your favourite movies in offline mode to view even when there is no internet available.

Movies use [The Movie DB API] (https://www.themoviedb.org/?language=en).

## User stories
### Required
- Home screen
  - [x] User can choose different settings to display like: most popular movies, most rated movies, favourite movies.
  - [x] On tapping on poster, user will be redirected to movie detail screen.
- Movie Detail screen  
  - [x] Show movie's details, includes title, poster, synopsis, user rating, release date.
  - [x] Display a list of available trailers for that movie. On tapping on trailer item, user can play the trailer in full screen and can rotate the device while playing.
  - [x] User can read the reviews of a selected movie.
  - [x] User can save the movie poster to the device gallery by long tapping on it and select “Save”.
  - [x] User can toggle a movie as a favourite in the details view by tapping a button (heart button). This action will add/remove the movie to local movies collection and do not need to make any API request.
- Login screen
  - [x] User can login to restore saved data.
- Customize for iPad
  - [x] Movies must work well on both iphone and ipad, with optimized experience for tablet.
- Sync with server
  - [x] Local movies collection will be synced with cloud services with user’s account. User must be able to create their account and keep their data private.


## Set up

We need to load some API keys from the `Movies/Config.plist` file.
Please request this file from me directly or copy `Movies/Config.plist.sample` to `Movies/Config.plist` and fill out your own values.

Pods aren't checked in to source control, so please run `pod install` then open `Movies.xcworkspace` and run in Xcode.
Tested Xcode version: 7.0.1


Credits
---------
* [RealmSwift](https://realm.io/)
* [Parse](https://parse.com/)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [HCSStarRatingView](https://github.com/hsousa/HCSStarRatingView)
* [SwiftSpinner](https://github.com/icanzilb/SwiftSpinner)
* [SWRevealViewController](https://github.com/John-Lluch/SWRevealViewController)
* [Cartography](https://github.com/robb/Cartography)
* [Reachability](https://github.com/tonymillion/Reachability)
* [Quick](https://github.com/Quick/Quick)
* [Nimble](https://github.com/Quick/Nimble)
* [KIF](https://github.com/kif-framework/KIF)
* [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs)
