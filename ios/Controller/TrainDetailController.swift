//
//  TrainDetailController.swift
//  ios
//
//  Created by hqy2000 on 7/16/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit

class TrainScheduleCell: UITableViewCell {
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var departTimeLabel: UILabel!
}

class TrainDiagramCell: UITableViewCell {
    @IBOutlet weak var diagramView: UIImageView!
}

class TrainDetailController: UITableViewController {
    var provider: CRProvider? = nil
    var train: String? = nil
    var date: Date? = nil
    
    var list: [TrainSchedule] {
        return provider?.schedules ?? []
    }
    
    override func viewDidLoad() {
        if let provider = self.provider, let train = self.train, let date = self.date {
            provider.getTrainDetail(withTrainNumber: train, date: date) {
                self.tableView.reloadData()
                self.title = train + " " + provider.schedules.first?.station_name ?? "" + " - " + provider.schedules.last?.station_name ?? ""
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "trainDiagramCell") as! TrainDiagramCell
            cell.diagramView.sd_setImage(with: URL(string: "https://emu.nfls.io")!.appendingPathComponent("img").appendingPathComponent(self.train! + ".png"), completed: nil)
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "trainScheduleCell") as! TrainScheduleCell
            cell.stationNameLabel.text = self.list[indexPath.row - 1].station_name
            cell.arriveTimeLabel.text = self.list[indexPath.row - 1].arrive_time
            cell.departTimeLabel.text = self.list[indexPath.row - 1].start_time
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.list.count > 0 {
            return self.list.count + 1
        } else {
            return 0
        }
    }
    
}
