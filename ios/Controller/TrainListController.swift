//
//  TrainListController.swift
//  ios
//
//  Created by hqy2000 on 7/14/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class TrainDetailCell: UITableViewCell {
    
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var fromStationLabel: UILabel!
    @IBOutlet weak var toStationLabel: UILabel!
    @IBOutlet weak var trainModelLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
}

class TrainListController: UITableViewController {
    var provider: CRProvider? = nil
    var moeRailProvider: MoeRailProvider? = nil
    var from: Station? = nil
    var to: Station? = nil
    var date: Date? = nil
    var list: [TrainTicket] {
        return self.provider?.tickets ?? []
    }
    var selected: Int = 0
    
    override func viewDidLoad() {
        if
            let provider = self.provider,
            let from = self.from,
            let to = self.to,
            let date = self.date {
            self.title = "\(self.from?.name ?? "") - \(self.to?.name ?? "")"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.navigationItem.prompt = dateFormatter.string(from: date)
            self.moeRailProvider = MoeRailProvider({ (_) in
                self.tableView.reloadData()
            })
            
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "加载中"
            hud.show(in: self.navigationController!.view)
            
            provider.getTrainList(from: from.telecode, to: to.telecode, date: date) { error in
                hud.dismiss()
                if let error = error {
                    let alert = UIAlertController(title: "错误", message: error, preferredStyle: .alert)
                    let action = UIAlertAction(title: "好的", style: .default, handler: { (_) in
                        alert.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
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
        if let model = self.moeRailProvider!.getTrainModel(self.list[indexPath.row].trainNumber) {
            cell.trainModelLabel.text = model
        } else {
            cell.trainModelLabel.text = "暂无数据"
        }
        for (index, element) in self.list[indexPath.row].getAvailableSeating().enumerated() {
            switch index {
            case 0:
                cell.label1.text = element
            case 1:
                cell.label2.text = element
            case 2:
                cell.label3.text = element
            case 3:
                cell.label4.text = element
            default:
                break
            }
        }
        // cell.accessoryType = .disclosureIndicator
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = indexPath.row
        self.performSegue(withIdentifier: "showTrainDetailController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TrainDetailController {
            controller.train = self.list[self.selected].trainNumber
            self.provider?.schedules = []
            controller.provider = self.provider
        }
    }
    
}
