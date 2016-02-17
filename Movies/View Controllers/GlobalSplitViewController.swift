//
//  GlobalSplitViewController.swift
//  Movies
//
//  Created by EastAgile16 on 11/13/15.
//  Copyright © 2015 EastAgile16. All rights reserved.
//

import UIKit

class GlobalSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    
    let leftNavController = viewControllers.first as! UINavigationController
    let masterViewController = leftNavController.topViewController as! HomeViewController
    
    let rightNavController = viewControllers.last as! UINavigationController
    let detailViewController = rightNavController.topViewController as! DetailsViewController
    
    masterViewController.delegate = detailViewController
    
    detailViewController.navigationItem.leftItemsSupplementBackButton = true
    detailViewController.navigationItem.leftBarButtonItem = displayModeButtonItem()
  }
  
  func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool{
    return true
  }
  
}
