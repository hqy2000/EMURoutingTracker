//
//  SettingController.swift
//  ios
//
//  Created by hqy2000 on 8/29/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Eureka

class SettingController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("版本")
            <<< LabelRow() {
                $0.title = "车站信息："
            }
            <<< LabelRow() {
                $0.title = "交路信息："
            }
            <<< ButtonRow() {
                $0.title = "清除本地缓存"
            }
            
            +++ Section("信息来源")
            <<< ButtonRow() {
                $0.title = "CRH380AL 动车组"
            }
            <<< ButtonRow() {
                $0.title = "Arnie97"
            }
            +++ Section()
            <<< ButtonRow() {
                $0.title = "开源组件许可证"
            }
    }
}
