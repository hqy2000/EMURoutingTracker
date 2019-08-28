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
    var date: Date? = Date()
    
    var list: [TrainSchedule] {
        return provider?.schedules ?? []
    }
    
    override func viewDidLoad() {
        if let provider = self.provider {
            provider.getTrainDetail(withTrainNumber: self.train ?? "", date: self.date ?? Date()) { message in
                if let message = message {
                    let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "好的", style: .default, handler: { (_) in
                       alert.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                        
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
          
                } else {
                    self.tableView.reloadData()
                    let from = self.provider?.schedules.first?.station_name ?? ""
                    let to = self.provider?.schedules.last?.station_name ?? ""
                    self.title = (self.train ?? "") + " " + from + " - " + to
                }
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
