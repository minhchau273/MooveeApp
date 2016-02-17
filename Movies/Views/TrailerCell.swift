//
//  TrailerCell.swift
//  Movies
//
//  Created by EastAgile16 on 11/2/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit
import AlamofireImage

class TrailerCell: UICollectionViewCell {
  
  @IBOutlet weak var thumbnailView: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var playView: UIView!
  
  var trailer: Trailer! {
    didSet {
      if let url = NSURL(string: trailer.thumbnailUrl) {
        thumbnailView.af_setImageWithURL(url)
        titleLabel.text = trailer.name
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    playView.backgroundColor = UIColor(red:160.0/255.0, green:160.0/255.0, blue:160.0/255.0, alpha:0.5)
    let tapGesture = UITapGestureRecognizer(target: self, action: "playVideo:")
    playView.addGestureRecognizer(tapGesture)
  }
  
  func playVideo(sender: UITapGestureRecognizer) {
    if Helper.hasConnectivity() {
      if let youTubeUrl = NSURL(string: trailer.youTubeUrl), safariUrl = NSURL(string: trailer.safariUrl) {
        if UIApplication.sharedApplication().canOpenURL(youTubeUrl)  {
          UIApplication.sharedApplication().openURL(youTubeUrl)
        } else {
          UIApplication.sharedApplication().openURL(safariUrl)
        }
      }
    } else {
      if let tableView = self.superview as? UICollectionView {
        let vc = tableView.dataSource as? UIViewController
        vc?.showNetworkErrorAlert()
      }
    }
  }
  
}
