//
//  UITableView+Extension.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 10/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit

/**
 The `UITableView` extension.
 */
extension UITableView {
    
    /**
     Hide search bar in the header of table view and show it when user drag down.
     */
    func hideSearchBarIfNeeded() {
        if let bar = self.tableHeaderView as? UISearchBar {
            let height = bar.frame.height
            let offset = self.contentOffset.y
            if offset < height {
                self.contentOffset = CGPoint(x: 0, y: height)
            }
        }
    }
}
