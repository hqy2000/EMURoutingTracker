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
import Eureka

class StationSearchController: UITableViewController, UISearchResultsUpdating, TypedRowControllerType {
    var row: RowOf<Station>!
    var onDismissCallback: ((UIViewController) -> Void)?
    var selected: Station? = nil
    var provider: StationProvider? = nil

    var filteredList: [Station] {
        get {
            return self.provider!.search(for: self.searchController.searchBar.text ?? "")
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience public init(_ callback: @escaping (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        self.onDismissCallback = callback
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "station")
        self.provider = StationProvider() { message in
            if let message = message {
                let alert = UIAlertController()
                alert.title = "错误"
                alert.message = message
                alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { (_) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            } else {
                self.tableView.reloadData()
            }
        }
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.isActive = false
        
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
            return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        } else {
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.searchController.isActive {
            return self.provider!.stations.filter({$0.pinyin_full.starts(with: String(UnicodeScalar(UInt8(97 + section))))}).count
        } else {
            return self.filteredList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "station")
        
        var current: [Station] = []
        if !self.searchController.isActive {
            current = self.provider!.stations.filter({$0.pinyin_full.starts(with: String(UnicodeScalar(UInt8(97 + indexPath.section))))})
        } else {
            current = self.filteredList
        }
        
        cell.textLabel?.text = current[indexPath.row].name
        cell.detailTextLabel?.text = current[indexPath.row].telecode
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.searchController.isActive {
            self.selected = self.provider!.stations.filter({$0.pinyin_full.starts(with: String(UnicodeScalar(UInt8(97 + indexPath.section))))})[indexPath.row]
        } else {
            self.selected = self.filteredList[indexPath.row]
        }
        self.onDismissCallback?(self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.tableView.reloadData()
    }
}
