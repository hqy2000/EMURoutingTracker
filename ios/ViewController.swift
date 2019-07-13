//
//  ViewController.swift
//  ios
//
//  Created by hqy2000 on 7/7/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("交路查询")
            <<< TextRow() { row in
                row.title = "车次"
                row.placeholder = "G1"
            }
            +++ Section("车型查询")
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
                $0.title = "查询"
                $0.onCellSelection({ (_, _) in
                    let provider = MoeRailProvider()
                    let fromRow: StationSearchRow = self.form.rowBy(tag: "from")!
                    let toRow: StationSearchRow = self.form.rowBy(tag: "to")!
                    let dateRow: DateRow = self.form.rowBy(tag: "date")!
                    provider.getLeftTicket(from: fromRow.value?.telecode ?? "", to: toRow.value?.telecode ?? "", date: dateRow.value ?? Date())
                })
            }
    }
}

