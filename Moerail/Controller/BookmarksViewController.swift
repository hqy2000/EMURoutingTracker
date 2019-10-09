//
//  BookmarksViewController.swift
//  ios
//
//  Created by Qingyang Hu on 10/4/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

class BookmarksViewController: UITableViewController {
    let provider = DynamicTrackingProvider()
    var list: [String] {
        return Defaults[.bookmarks].sorted()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.icon(from: .fontAwesome, code: "bookmark", iconColor: .blue, imageSize: CGSize(width: 20, height: 20), ofSize: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (self.list.count > 0) {
            provider.getTrackingRecords(keywords: self.list) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.textLabel?.text = self.list[indexPath.row]
        let train = self.provider.batch.filter { (model) -> Bool in
            return model.train == self.list[indexPath.row]
        }
        if (train.count == 1) {
            cell.detailTextLabel?.text = train[0].emu + " @ " + train[0].date
        } else {
            cell.detailTextLabel?.text = "暂无数据"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "trainDetailController") as! TrainDetailController
        controller.provider = CRProvider()
        controller.train = self.list[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
