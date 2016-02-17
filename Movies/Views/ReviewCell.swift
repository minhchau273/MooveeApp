//
//  ReviewCell.swift
//  Movies
//
//  Created by EastAgile16 on 11/2/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit

@objc protocol ReviewCellDelegate {
  optional func reviewCell(reviewCell: ReviewCell, onTapReadMore: AnyObject?)
}

class ReviewCell: UITableViewCell {
  
  @IBOutlet weak var authorLabel: UILabel!
  
  @IBOutlet weak var contentLabel: UILabel!
  
  @IBOutlet weak var readMoreButton: UIButton!
  
  var isExpanded = false
  
  weak var delegate: ReviewCellDelegate?
  
  var review: Review! {
    didSet {
      authorLabel.text = review.author.uppercaseString
      contentLabel.text = review.content
      
      if countLabelLines(contentLabel) > 3 {
        if isExpanded {
          contentLabel.numberOfLines = 0
          readMoreButton.setTitle("Read less", forState: .Normal)
        } else {
          contentLabel.numberOfLines = 3
          readMoreButton.setTitle("Read more", forState: .Normal)
        }
        if let buttonTitle = readMoreButton.titleLabel?.text! {
          readMoreButton.accessibilityLabel = "\(buttonTitle)-\(review.author)"
        }
        setReadMoreEnabled(true)
      } else {
        setReadMoreEnabled(false)
      }
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if review != nil && isExpanded {
      contentLabel.preferredMaxLayoutWidth = contentLabel.frame.size.width
    }
  }
  
  func countLabelLines(label:UILabel) -> Int {
    if let text = label.text {
      let myText = text as NSString
      let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(UIFont.systemFontSize())]
      
      // Calculate actual size of UILabel before truncating
      let labelSize = myText.boundingRectWithSize(CGSizeMake(label.bounds.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
      
      let lines = ceil(CGFloat(labelSize.height) / label.font.lineHeight)
      return Int(lines)
    }
    
    return 0
  }
  
  func setReadMoreEnabled(enabled: Bool) {
    readMoreButton.enabled = enabled
    readMoreButton.setTitleColor(enabled ? Color.primaryColor : Color.actionButtonColor, forState: .Normal)
  }
  
  @IBAction func onReadMoreTapped(sender: UIButton) {
    delegate?.reviewCell?(self, onTapReadMore: nil)
  }
  
}
