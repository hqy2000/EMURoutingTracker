//
//  DiagramSearchController.swift
//  ios
//
//  Created by hqy2000 on 7/9/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class DiagramSearchController: UIViewController, UISearchResultsUpdating {
   
    @IBOutlet weak var imageView: UIImageView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController.searchResultsUpdater = self
        self.definesPresentationContext = false
        self.navigationItem.titleView = self.searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text != "" {
            self.imageView.sd_setImage(with: URL(string: "https://emu.nfls.io")?.appendingPathComponent("img").appendingPathComponent(text + ".png"), completed: nil)
        }
        
    }
}
