//
//  StationSearchController.swift
//  ios
//
//  Created by hqy2000 on 7/10/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit
import Moya

class StationSearchController: UITableViewController, UISearchResultsUpdating {
    
    var list: StationList? = nil
    var filteredList: [StationList.Station] {
        get {
            if let list = self.list {
                return list.list.filter({$0.pinyin_full.starts(with: (self.searchController.searchBar.text?.lowercased())!)})
            } else {
                return []
            }
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        let provider = MoeRailProvider()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "station")
        provider.getStations { (list) in
            self.list = list
            dump(self.list)
            self.tableView.reloadData()
        }
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !self.searchController.isActive {
            return 26
        } else {
            return 1
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !self.searchController.isActive {
            return String(UnicodeScalar(UInt8(65 + section)))
        } else {
            return ""
        }
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !self.searchController.isActive {
            return ["®A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        } else {
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.list {
            if !self.searchController.isActive {
                 return list.list.filter({$0.pinyin_full.starts(with: String(UnicodeScalar(UInt8(97 + section))))}).count
            } else {
                return self.filteredList.count
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "station")
        if let list = self.list {
            var current: [StationList.Station] = []
            if !self.searchController.isActive {
                current = list.list.filter({$0.pinyin_full.starts(with: String(UnicodeScalar(UInt8(97 + indexPath.section))))})
            } else {
                current = self.filteredList
            }
            
            cell.textLabel?.text = current[indexPath.row].name
            cell.detailTextLabel?.text = current[indexPath.row].telecode
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.tableView.reloadData()
    }
}
