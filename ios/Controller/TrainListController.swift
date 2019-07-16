//
//  TrainListController.swift
//  ios
//
//  Created by hqy2000 on 7/14/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit

class TrainDetailCell: UITableViewCell {
    
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var fromStationLabel: UILabel!
    @IBOutlet weak var toStationLabel: UILabel!
    @IBOutlet weak var trainModelLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
}

class TrainListController: UITableViewController {
    var provider: CRProvider? = nil
    var from: Station? = nil
    var to: Station? = nil
    var date: Date? = nil
    var list: [TrainTicket] {
        return self.provider?.tickets ?? []
    }
    
    override func viewDidLoad() {
        if
            let provider = self.provider,
            let from = self.from,
            let to = self.to,
            let date = self.date {
            provider.getTrainList(from: from.telecode, to: to.telecode, date: date) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainDetailCell", for: indexPath) as! TrainDetailCell
        cell.beginTimeLabel.text = self.list[indexPath.row].start
        cell.endTimeLabel.text = self.list[indexPath.row].end
        cell.toStationLabel.text = self.provider!.stationProvider.getStation(withTelecode: self.list[indexPath.row].to)?.name ?? ""
        cell.fromStationLabel.text = self.provider!.stationProvider.getStation(withTelecode: self.list[indexPath.row].from)?.name ?? ""
        cell.trainNumberLabel.text = self.list[indexPath.row].trainNumber
        return cell
    }
    
    
}
