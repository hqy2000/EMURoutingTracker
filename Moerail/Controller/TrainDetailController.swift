//
//  TrainDetailController.swift
//  ios
//
//  Created by hqy2000 on 7/16/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD
import QuickLook
import SafariServices
import SDWebImage
import SwiftyUserDefaults

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
    var trackingProvider = DynamicTrackingProvider()
    var train: String? = nil
    var date: Date? = Date()
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var list: [TrainSchedule] {
        return provider?.schedules ?? []
    }
    
    var models: [TrainModel] {
        return trackingProvider.list
    }
    
    var hasSchedule: Bool = true
    var hasDiagram: Bool = true
    var hasTracking: Bool = true
    
    var isSectionVisible: [Bool] {
        return [hasDiagram, hasTracking, hasSchedule]
    }
    
    var pending = 2 {
        didSet {
            if pending == 0 {
                self.activityIndicator.stopAnimating()
                
                if self.hasDiagram && self.hasSchedule, train != nil {
                    
                    self.alterNavbar()
                }
            }
        }
    }
    
    @objc private func operateBookmark(sender: UIBarButtonItem) {
        if let train = train {
            var list: [String] = Defaults[.bookmarks]
            if (!list.contains(train)) {
                list.append(train)
            } else {
                list.remove(at: list.index(of: train)!)
            }
            Defaults[.bookmarks] = list
            self.alterNavbar()
        }
    }
    
    private func alterNavbar() {
        if let train = train {
            var list: [String] = Defaults[.bookmarks]
            if (!list.contains(train)) {
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(operateBookmark(sender:))), animated: true)
            } else {
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(operateBookmark(sender:))), animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        let barButton = UIBarButtonItem(customView: self.activityIndicator)
        self.activityIndicator.color = .gray
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        if ((train ?? "").contains("K") || (train ?? "").contains("Z") || (train ?? "").contains("T")) {
            self.hasTracking = false
            self.tableView.reloadData()
            self.pending -= 1
        } else {
            self.trackingProvider.getTrackingRecord(keyword: train ?? "", completion: {
                self.pending -= 1
                if self.models.count == 0 {
                    self.hasTracking = false
                }
                self.tableView.reloadData()
            })
        }
        
        self.tableView.register(UINib(nibName: "TrainEmuCell", bundle: Bundle.main), forCellReuseIdentifier: "emuCell")
        
        
        
        
        self.title = self.train
        
        if let provider = self.provider {
            provider.getTrainDetail(withTrainNumber: self.train ?? "", date: self.date ?? Date()) { message in
                self.pending -= 1
                if let message = message {
                    if message != "车次不正确" {
                        let alert = UIAlertController(title: "时刻表加载错误", message: message, preferredStyle: .alert)
                        let action = UIAlertAction(title: "好的", style: .default, handler: { (_) in
                            alert.dismiss(animated: true, completion: nil)
                            // self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.hasSchedule = false
                    self.tableView.reloadData()
                    
                    
                } else {
                    let from = self.provider?.schedules.first?.station_name ?? ""
                    let to = self.provider?.schedules.last?.station_name ?? ""
                    self.title = (self.train ?? "") + " " + from + " - " + to
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if self.hasDiagram {
                return self.getDiagramCell(cellForRowAt: indexPath)
            } else {
                return self.getNoneCell()
            }
            
        } else if indexPath.section == 1 {
            if self.hasTracking {
                return self.getTrackingCell(cellForRowAt: indexPath)
            } else {
                return self.getNoneCell()
            }
            
        } else {
            if self.hasSchedule {
                return self.getScheduleCell(cellForRowAt: indexPath)
            } else {
                return self.getNoneCell()
            }
            
        }
    }
    
    private func getDiagramCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "trainDiagramCell") as! TrainDiagramCell
        if (!self.train!.starts(with: "G") && !self.train!.starts(with: "D")) {
            self.hasDiagram = false
            self.tableView.reloadData()
        } else {
            cell.diagramView.sd_setImage(with: URL(string: "https://emu.nfls.io")!.appendingPathComponent("img").appendingPathComponent(self.train! + ".png"), completed: { (_, error, _, _) in
                if let error = error as? SDWebImageError, error.code != SDWebImageError.invalidDownloadOperation {
                    if error.code == SDWebImageError.invalidDownloadStatusCode, let code = error.userInfo[SDWebImageErrorDownloadStatusCodeKey] as? Int, code != 404 {
                        let alert = UIAlertController(title: "交路表加载错误", message: "服务器错误：\(code)，请稍后再试。", preferredStyle: .alert)
                        let action = UIAlertAction(title: "好的", style: .default, handler: { (_) in
                            alert.dismiss(animated: true, completion: nil)
                            // self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    self.hasDiagram = false
                    self.tableView.reloadData()
                }
            })
        }
        return cell
    }
    
    
    private func getTrackingCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "emuCell", for: indexPath) as! TrainEmuCell
        cell.title.text = self.models[indexPath.row].emu
        cell.subtitle?.text = self.models[indexPath.row].train
        cell.remark.text = self.models[indexPath.row].date
        return cell
    }
    
    private func getScheduleCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "trainScheduleCell") as! TrainScheduleCell
        cell.stationNameLabel.text = self.list[indexPath.row].station_name
        cell.arriveTimeLabel.text = self.list[indexPath.row].arrive_time
        cell.departTimeLabel.text = self.list[indexPath.row].start_time
        return cell
    }
    
    private func getNoneCell() -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "trainModelCell") as! UITableViewCell
        cell.textLabel?.text = "无"
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //    return ["交", "运", "时"]
    // }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["交路表","运用表","时刻表"][section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var counts: [Int] = []
        if self.hasDiagram {
            counts.append(1)
        } else {
            counts.append(1)
        }
        if self.hasTracking {
            counts.append(self.models.count)
        } else {
            counts.append(1)
        }
        if self.hasSchedule {
            counts.append(self.list.count)
        } else {
            counts.append(1)
        }
        return counts[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let alert = UIAlertController(title: "请选择", message: nil, preferredStyle: .alert)
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "trainDetailController") as! TrainDetailController
            controller.provider = self.provider
            
            let emu = UIAlertAction(title: self.models[indexPath.row].emu, style: .default) { (_) in
                controller.train = self.models[indexPath.row].emu
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            let train = UIAlertAction(title: self.models[indexPath.row].train, style: .default) { (_) in
                var train = self.models[indexPath.row].train
                if train.contains("/") {
                    train = train.components(separatedBy: "/")[0]
                }
                controller.train = train
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
            // let cell = tableView.dequeueReusableCell(withIdentifier: "trainModelCell", for: indexPath)
            // alert.popoverPresentationController?.sourceView = cell.contentView
            // alert.popoverPresentationController?.sourceRect = cell.contentView.frame
            
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(emu)
            alert.addAction(train)
            alert.addAction(cancel)
            
            self.present(alert, animated: true)
            
        } else if indexPath.section == 0 {
            let controller = SFSafariViewController(url: URL(string: "https://moerail.ml")!.appendingPathComponent("img").appendingPathComponent(self.train! + ".png"))
            self.present(controller, animated: true)
        }
    }
    
}

/*
extension TrainDetailController: QLPreviewControllerDataSource {
    
}
 */
