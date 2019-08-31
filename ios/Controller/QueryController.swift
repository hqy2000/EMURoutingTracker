//
//  ViewController.swift
//  ios
//
//  Created by hqy2000 on 7/7/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import UIKit
import Eureka
import SwiftIconFont

class QueryController: FormViewController, UISearchBarDelegate {
    
    let provider = CRProvider()
    let moeProvider = MoeRailProvider({_ in})
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.icon(from: .fontAwesome, code: "search", iconColor: .blue, imageSize: CGSize(width: 20, height: 20), ofSize: 20)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("交路信息")
            <<< TextRow() { row in
                row.placeholder = "车次，车型，或是车组号"
                row.tag = "train"
            }
            <<< DateRow() {
                $0.title = "日期"
                $0.value = Date()
                $0.tag = "train_date"
                $0.hidden = true
            }
            <<< ButtonRow() {
                $0.title = "综合查询"
                $0.onCellSelection({ (_, _) in
                   self.performSegue(withIdentifier: "showTrainDetailController", sender: nil)
                })
            }
    
            +++ Section("车次信息")
            <<< StationSearchRow() {
                $0.title = "起点"
                $0.tag = "from"
            }
            <<< StationSearchRow() {
                $0.title = "终点"
                $0.tag = "to"
            }
            <<< DateRow() {
                $0.title = "乘车日期"
                $0.value = Date()
                $0.tag = "date"
            }
            <<< ButtonRow() {
                $0.title = "批量查询"
                $0.onCellSelection({ (_, _) in
                    self.performSegue(withIdentifier: "showTrainListController", sender: nil)
                })
            }
            /*
            +++ Section("车站信息")
            <<< StationSearchRow() {
                $0.title = "车站"
            }
            <<< DateRow() {
                $0.title = "日期"
            }
            <<< ButtonRow() {
                $0.title = "查询"
            }
            */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let controller = segue.destination as? TrainListController {
            let fromRow: StationSearchRow = self.form.rowBy(tag: "from")!
            let toRow: StationSearchRow = self.form.rowBy(tag: "to")!
            let dateRow: DateRow = self.form.rowBy(tag: "date")!
            
            controller.provider = self.provider
            controller.to = toRow.value
            controller.from = fromRow.value
            controller.date = dateRow.value
            
        } else if let controller = segue.destination as? TrainDetailController {
            let trainRow: TextRow = self.form.rowBy(tag: "train")!
            let dateRow: DateRow = self.form.rowBy(tag: "train_date")!
            
            controller.provider = self.provider
            controller.train = trainRow.value?.uppercased()
            controller.date = dateRow.value
        }
    }
    
}

