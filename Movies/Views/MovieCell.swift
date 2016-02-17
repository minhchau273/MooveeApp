//
//  MovieCell.swift
//  Movies
//
//  Created by EastAgile16 on 10/26/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UICollectionViewCell {
  
  @IBOutlet weak var posterImage: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  weak var movie: Movie! {
    didSet {
      titleLabel.text = "\(movie.title.uppercaseString) (\(movie.releaseYear))"
      
      if movie.thumbnailPoster.isEmpty {
        posterImage.image = UIImage(named: "NoImage")
        posterImage.contentMode = .ScaleAspectFit
      } else {
        if movie.isLiked {
          if !movie.posterLocalPath.isEmpty {
            if let localImage = UIImage(contentsOfFile: movie.posterLocalPath) {
              posterImage.image = localImage
            }
          }
        } else {
          if let imageUrl = NSURL(string: movie.thumbnailPoster) {
            posterImage.af_setImageWithURL(imageUrl)
          }
        }
      }
    }
  }
}
