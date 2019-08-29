//
//  TicketQueryReusltController.swift
//  ios
//
//  Created by hqy2000 on 7/13/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit

class TrainModelListController: UITableViewController {
    var trackingProvider = DynamicTrackingProvider()
    var keyword: String? = nil
    var list: [TrainModel] {
        return trackingProvider.list
    }
    
    override func viewDidLoad() {
        if let keyword = keyword {
            self.trackingProvider.getTrackingRecord(keyword: keyword) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
