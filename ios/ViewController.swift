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
       
        let provider = MoeRailProvider()
        provider.getStations { (list) in
            self.form +++ Section("车型查询")
                <<< PushRow<String>() {
                    $0.title = "起点"
                    $0.options = list.list.map({$0.name})
                }
        }
    }


}

