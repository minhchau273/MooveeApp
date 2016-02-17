//
//  ViewController.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner
import Parse
import SWRevealViewController
import RealmSwift
import Reachability

protocol MovieSelectionDelegate: class {
  func movieSelected(id: Int)
}

class HomeViewController: UIViewController {
  
  @IBOutlet weak var menuButton: UIBarButtonItem!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var typeSegment: UISegmentedControl!
  
  @IBOutlet weak var messageLabel: UILabel!
  
  @IBOutlet weak var errorView: UIView!
  
  weak var delegate: MovieSelectionDelegate?
  
  var popularMovies = [Movie]()
  var mostRatedMovies = [Movie]()
  
  var currentSegment = SegmentType.Popular
  var popularPage = 1
  var mostRatedPage = 1
  
  var loadingView: UIActivityIndicatorView!
  var reach: Reachability?
  
  // MARK: - Main funcitons
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setLogoAsTitle()
    configMenuSide()
    addFooterView()
    configReachability()
    if Helper.hasConnectivity() {
      requestData(withLoadMore: false)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if currentSegment == .Favorite {
      collectionView.reloadData()
      if moviesBasedOnSegment(currentSegment).count == 0 {
        showMessageAndHideMovies(message: noFavoriteMessage)
      }
    } else {
      if !Helper.hasConnectivity() {
        UIView.animateWithDuration(1) { self.errorView.alpha = 1 }
        showMessageAndHideMovies(message: networkErrorMessage)
      }
    }
  }
  
  func setLogoAsTitle() {
    let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    logo.image = UIImage(named: "Logo")
    logo.contentMode = .ScaleAspectFit
    navigationItem.titleView = logo
  }
  
  func configMenuSide() {
    if let revealViewController = revealViewController() {
      menuButton.target = revealViewController
      menuButton.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
    }
  }
  
  func requestData(withLoadMore withLoadMore: Bool) {
    var type = ListType.Popular
    var page = 1
    
    switch currentSegment {
    case .Popular:
      type = ListType.Popular
      page = withLoadMore ? ++popularPage : popularPage
    case .MostRated:
      type = ListType.MostRated
      page = withLoadMore ? ++mostRatedPage : mostRatedPage
    case .Favorite:
      if moviesBasedOnSegment(currentSegment).count == 0 || PFUser.currentUser() == nil {
        showMessageAndHideMovies(message: noFavoriteMessage)
      }
      return
    }
    
    MovieClient.getMovies(type, page: page) { (movies, error) -> () in
      if let movies = movies {
        switch self.currentSegment {
        case .Popular:
          for movie in movies {
            self.popularMovies.append(movie)
          }
        case .MostRated:
          for movie in movies {
            self.mostRatedMovies.append(movie)
          }
        case .Favorite:
          return
        }
        self.showMoviesAndReloadData()
        self.loadingView.hidden = true
        SwiftSpinner.hide()
      }
    }
  }
  
  func addFooterView() {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
    loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    loadingView.center = footerView.center
    footerView.addSubview(loadingView)
    collectionView.addSubview(footerView)
  }
  
  func moviesBasedOnSegment(segment: SegmentType) -> [Movie] {
    switch segment {
    case .Popular: return popularMovies
    case .MostRated: return mostRatedMovies
    case .Favorite: return Movie.allFavorites
    }
  }
  
  @IBAction func onSegmentChanged(sender: UISegmentedControl) {
    guard let selectedSegmentType = SegmentType(rawValue: sender.selectedSegmentIndex) else {
      return
    }
    currentSegment = selectedSegmentType
    
    if !Helper.hasConnectivity() && currentSegment != .Favorite {
      showMessageAndHideMovies(message: networkErrorMessage)
    } else {
      // In each segment, when switch from another segment,
      // if app hasn't requested more movies yet (still at page 1),
      // scoll to top of collection view
      // Example:
      // In Popular segment, app has requested to page 3
      // <=> The table view is at the ~50th row
      // When switch to Most rated segment,
      // if this segment is still at page 1, scroll to top
      if (currentSegment == .Popular && popularPage == 1) || (currentSegment == .MostRated && mostRatedPage == 1) {
        if moviesBasedOnSegment(currentSegment).count > 0 {
          // Scroll collection view to top
          collectionView.contentOffset = CGPointMake(0, 0 - self.collectionView.contentInset.top)
        }
      }
      
      showMoviesAndReloadData()
      requestData(withLoadMore: false)
    }
    
  }
  
  func showMoviesAndReloadData() {
    collectionView.reloadData()
    collectionView.hidden = false
    messageLabel.hidden = true
  }
  
}

// MARK: - Collection View

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let width = (self.view.bounds.width - 30) / 2
    let height = width * 1.6
    return CGSize(width: width, height: height)
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return moviesBasedOnSegment(currentSegment).count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
    
    loadDataToCollectionView(moviesBasedOnSegment(currentSegment), cell: cell, indexPath: indexPath)
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let selectedMovie = moviesBasedOnSegment(currentSegment)[indexPath.row]
    delegate?.movieSelected(selectedMovie.id)
    
    if let detailVC = delegate as? DetailsViewController, detailNavigationController = detailVC.navigationController {
      splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
    }
  }
  
  func loadDataToCollectionView(movies: [Movie], cell: MovieCell, indexPath: NSIndexPath) {
    cell.movie = movies[indexPath.row]
    if currentSegment != .Favorite && indexPath.row == movies.count - 1 {
      loadingView.startAnimating()
      loadingView.hidden = false
      requestData(withLoadMore: true)
    }
  }
  
}

// MARK: - Reachability

extension HomeViewController {
  
  func configReachability() {
    reach = Reachability.reachabilityForInternetConnection()
    // Allocate a reachability object
    if let reach = reach {
      // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
      reach.reachableOnWWAN = false
      
      NSNotificationCenter.defaultCenter().addObserver(self,
        selector: "reachabilityChanged:",
        name: kReachabilityChangedNotification,
        object: nil)
      
      reach.startNotifier()
    }
  }
  
  func reachabilityChanged(notification: NSNotification) {
    if let reach = reach {
      if reach.isReachableViaWiFi() || reach.isReachableViaWWAN() {
        UIView.animateWithDuration(1) { self.errorView.alpha = 0 }
        showMoviesAndReloadData()
      } else {
        UIView.animateWithDuration(1) { self.errorView.alpha = 1 }
        if currentSegment != .Favorite {
          showMessageAndHideMovies(message: networkErrorMessage)
        }
      }
    }
  }
  
  func showMessageAndHideMovies(message message: String) {
    collectionView.hidden = true
    messageLabel.hidden = false
    messageLabel.text = message
  }
  
  @IBAction func onCloseErrorButtonTapped(sender: UIButton) {
    UIView.animateWithDuration(1) { self.errorView.alpha = 0 }
  }
  
}
