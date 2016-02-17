//
//  DetailsViewController.swift
//  Movies
//
//  Created by EastAgile16 on 11/2/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit
import Alamofire
import HCSStarRatingView
import SwiftSpinner
import Cartography
import RealmSwift
import Parse

class DetailsViewController: UIViewController {
  
  @IBOutlet weak var posterImage: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var starView: UIView!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var likeButton: UIButton!
  
  @IBOutlet weak var overviewView: UIView!
  
  @IBOutlet weak var overviewLabel: UILabel!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var noTrailerLabel: UILabel!
  
  @IBOutlet weak var noReviewLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var detailsView: UIView!
  
  @IBOutlet weak var reviewsView: UIView!
  
  @IBOutlet weak var contentSegment: UISegmentedControl!
  
  @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var posterWidthConstraint: NSLayoutConstraint!
  
  var selectedMovieId: Int! {
    didSet {
      if viewWasLoaded {
        setMovieDetails()
      }
    }
  }
  
  var selectedMovie: Movie!
  var viewWasLoaded = false
  var overviewText: UITextView!
  var reviewStatus = [Int: Bool]()
  
  // MARK: - Main funcitons
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewWasLoaded = true
    
    customizeUIForSuitableDevice()
    configReviewsTab()
    
    // Add long press gesture to save poster
    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "posterLongPressed:")
    posterImage.addGestureRecognizer(longPressRecognizer)
    
    if selectedMovieId != nil {
      setMovieDetails()
    } else {
      view.hidden = true
    }
  }
  
  func customizeUIForSuitableDevice() {
    if IDIOM == IPHONE {
      // Set poster's size based on device
      let width = self.view.layer.bounds.width * 0.3
      posterWidthConstraint.constant = width
      posterHeightConstraint.constant = width * 1.6
      
      // If this device is iPhone,
      // using UITextField to display overview instead of UILabel
      overviewLabel.hidden = true
      
      // Add height constraint for collection view
      constrain(collectionView) { collectionView in
        collectionView.height == 140
      }
      
      // Create text view to show overview
      createTextView()
    }
  }
  
  func createTextView() {
    // Create text view
    overviewText = UITextView(frame: CGRect(x: 0, y: 0, width: overviewView.frame.width, height: overviewView.frame.height))
    overviewText.font = UIFont.systemFontOfSize(15)
    
    overviewText.editable = false
    overviewView.addSubview(overviewText)
    
    // Add constraints for text view
    constrain(overviewText, overviewView) { overviewText, overviewView in
      overviewText.edges == overviewView.edges
    }
  }
  
  func configReviewsTab() {
    tableView.registerNib(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 129
    tableView.tableFooterView = UIView()
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    reviewsView.hidden = true
  }
  
  func setMovieDetails() {
    if selectedMovieId != 0 {
      SwiftSpinner.show("Loading movie...")
      
      if let favoriteMovie = Movie.getFavoriteMovieFromId(selectedMovieId) {
        selectedMovie = favoriteMovie
        loadReviewsToTableView()
        setDetails()
        
        SwiftSpinner.hide()
      } else {
        MovieClient.getMovieWithTrailers(selectedMovieId, completion: { (movie, error) -> () in
          if let movie = movie {
            self.selectedMovie = movie
            self.getReviews()
            self.setDetails()
          }
          SwiftSpinner.hide()
        })
      }
      
    }
  }
  
  func setPoster() {
    if selectedMovie.isLiked {
      if !selectedMovie.posterLocalPath.isEmpty {
        if let localImage = UIImage(contentsOfFile: selectedMovie.posterLocalPath) {
          posterImage.image = localImage
          return
        }
      }
    } else {
      if let imageUrl = NSURL(string: selectedMovie.originalPoster), placeholderImageUrl = NSURL(string: selectedMovie.lowResolutionPoster) {
        if let imageData = NSData(contentsOfURL: placeholderImageUrl) {
          let placeholderImg = UIImage(data: imageData)
          self.posterImage.af_setImageWithURL(imageUrl, placeholderImage: placeholderImg)
          return
        }
      }
    }
    
    // If cannot get image from server or local DB
    self.posterImage.image = UIImage(named: "NoImage")
  }
  
  func setRatingStar(rating: Double) {
    let starViewWidth = starView.layer.bounds.width
    let starWidth = IDIOM == IPHONE ? starViewWidth * 0.9 : starViewWidth * 0.4
    let starRatingView = HCSStarRatingView(frame: CGRect(x: 0, y: 0, width: starWidth, height: 20))
    starRatingView.maximumValue = 10
    starRatingView.minimumValue = 0
    starRatingView.tintColor = Color.primaryColor
    starRatingView.allowsHalfStars = true
    starRatingView.accurateHalfStars = true
    starRatingView.value = CGFloat(rating)
    starView.addSubview(starRatingView)
  }
  
  @IBAction func onSegmentChanged(sender: UISegmentedControl) {
    // If this is Details segment, hide Reviews table view
    if sender.selectedSegmentIndex == 0 {
      hideReviews(true)
    } else {
      hideReviews(false)
    }
  }
  
  func hideReviews(isHidden: Bool) {
    detailsView.hidden = !isHidden
    reviewsView.hidden = isHidden
  }
  
}

// MARK: - Save Poster

extension DetailsViewController {
  
  func posterLongPressed(sender: UILongPressGestureRecognizer) {
    let actionSheet = UIAlertController(title: "Save Poster", message: "Would you want to save this poster to your photos?", preferredStyle: .ActionSheet)
    
    let savePoster = { (action: UIAlertAction!) in
      UIImageWriteToSavedPhotosAlbum(self.posterImage.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    actionSheet.addAction(UIAlertAction(title: "Yes", style: .Default, handler: savePoster))
    actionSheet.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
    
    // Display popover if this devide is iPad
    if let presentationController = actionSheet.popoverPresentationController {
      presentationController.sourceView = self.view
      presentationController.sourceRect = CGRect(x: sender.locationInView(self.view).x, y: sender.locationInView(self.view).y, width: 300, height: 100)
    }
    
    presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
    if error == nil {
      showMessageBox(title: "Successfully", message: "This poster has been saved to your photos.", actionTitle: "OK")
    } else {
      showMessageBox(title: "Error", message: error?.localizedDescription, actionTitle: "OK")
    }
  }
  
}

extension DetailsViewController: MovieSelectionDelegate {
  func movieSelected(id: Int) {
    selectedMovieId = id
  }
}

// MARK: - Handle add favorite movie
extension DetailsViewController {
  @IBAction func onLikeButtonTapped(sender: UIButton) {
    if !selectedMovie.isLiked {
      // Like movie
      if Helper.hasConnectivity() {
        if PFUser.currentUser() != nil {
          SwiftSpinner.show("Saving...")
          selectedMovie.isLiked = true
          selectedMovie.save({ (error) -> () in
            SwiftSpinner.hide()
            if error == nil {
              self.likeButton.setImage(UIImage(named: "Liked"), forState: .Normal)
              self.likeButton.accessibilityLabel = "Liked Button"
            } else {
              self.showMessageBox(title: "Oops", message: "Unable to add this movie to the favorites. Please try again leter.", actionTitle: "OK")
            }
          })
        } else {
          showMessageBox(title: "Please sign in to save this movie to your favorites!", message: nil, actionTitle: "OK")
        }
      } else {
        showNetworkErrorAlert()
      }
    } else {
      // Unlike movie
      if Helper.hasConnectivity() {
        let duplicatedMovie = selectedMovie.duplicate()
        selectedMovie.delete()
        selectedMovie = duplicatedMovie
        selectedMovie.isLiked = false
        likeButton.setImage(UIImage(named: "NotLike"), forState: .Normal)
        likeButton.accessibilityLabel = "Not Like Button"
        
      } else {
        showNetworkErrorAlert()
      }
    }
  }
}

//--------------------------------------
// MARK: - --- Overview + Trailers ---
//--------------------------------------

extension DetailsViewController {
  
  func setDetails() {
    title = selectedMovie.title
    titleLabel.text = selectedMovie.title.uppercaseString
    dateLabel.text = selectedMovie.releaseDateFormat
    view.hidden = false
    contentSegment.selectedSegmentIndex = 0
    
    setOverview()
    setPoster()
    setTrailer()
    hideReviews(true)
    setRatingStar(selectedMovie.voteAverage)
    likeButton.setImage(UIImage(named: selectedMovie.isLiked ?  "Liked": "NotLike"), forState: .Normal)
    likeButton.accessibilityLabel = selectedMovie.isLiked ? "Liked Button" : "Not Like Button"
  }
  
  func setOverview() {
    if IDIOM == IPHONE {
      overviewText.text = selectedMovie.overview
    } else {
      overviewLabel.text = selectedMovie.overview
    }
  }
  
  func setTrailer() {
    if selectedMovie.trailers.count > 0 {
      noTrailerLabel.hidden = true
      collectionView.hidden = false
      collectionView.reloadData()
    } else {
      noTrailerLabel.hidden = false
      collectionView.hidden = true
    }
  }
  
}

// MARK: - Collection View

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    if IDIOM == IPHONE {
      let width = (self.view.bounds.width - 50) / 2
      let height = width * 0.8
      return CGSize(width: width, height: height)
    } else {
      let width = (self.view.bounds.width - 100) / 4
      let height = width * 0.8
      return CGSize(width: width, height: height)
    }
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let selectedMovie = selectedMovie {
      return selectedMovie.trailers.count
    } else {
      return 0
    }
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TrailerCell", forIndexPath: indexPath) as! TrailerCell
    let trailer = selectedMovie.trailers[indexPath.row]
    cell.trailer = trailer
    return cell
  }
  
}

//--------------------------------------
// MARK: - --- Reviews ---
//--------------------------------------

extension DetailsViewController {
  
  func getReviews() {
    if let selectedMovie = selectedMovie {
      let page = getReviewPage(selectedMovie)
      if page != 0 {
        MovieClient.getReviews(selectedMovie, page: page) { (reviews, totalPages, error) -> () in
          if let reviews = reviews {
            self.selectedMovie.currentReviewPage = page
            self.selectedMovie.totalReviewPages = totalPages
            self.selectedMovie.reviews.appendContentsOf(reviews)
            self.loadReviewsToTableView()
          }
        }
      }
    }
  }
  
  func getReviewPage(movie: Movie) -> Int {
    var page = 0
    if movie.totalReviewPages == 0 {
      page = 1
    } else {
      if movie.currentReviewPage < movie.totalReviewPages {
        page = ++movie.currentReviewPage
      }
    }
    return page
  }
  
  func loadReviewsToTableView() {
    if selectedMovie.reviews.count > 0 {
      tableView.reloadData()
      noReviewLabel.hidden = true
      tableView.hidden = false
      
      // Store expand status in array
      for index in 0..<selectedMovie.reviews.count {
        reviewStatus[index] = false
      }
    } else {
      noReviewLabel.hidden = false
      tableView.hidden = true
    }
  }
  
}

// MARK: - Table View

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if let selectedMovie = selectedMovie {
      return selectedMovie.reviews.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as! ReviewCell
    cell.isExpanded = reviewStatus[indexPath.section]!
    cell.review = selectedMovie.reviews[indexPath.section]
    cell.delegate = self
    cell.setSeparatorFullWidth()
    
    if !selectedMovie.isLiked && indexPath.row == selectedMovie.reviews.count - 1 {
      getReviews()
    }
    return cell
  }
  
}

// MARK: - Review Cell

extension DetailsViewController: ReviewCellDelegate {
  func reviewCell(reviewCell: ReviewCell, onTapReadMore: AnyObject?) {
    if let indexPath = tableView.indexPathForCell(reviewCell) {
      if let value = reviewStatus[indexPath.section] {
        reviewStatus[indexPath.section] = !value
      }
      tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
  }
}
