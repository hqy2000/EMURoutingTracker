//
//  SettingController.swift
//  ios
//
//  Created by hqy2000 on 8/29/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Eureka
import SwiftyUserDefaults
import SafariServices

class SettingController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("版本")
            <<< LabelRow() {
                $0.title = "车站信息：" + Defaults[.stationDatabaseVersion]
            }
            <<< LabelRow() {
                $0.title = "交路信息：" + Defaults[.trainDatabaseVersion]
            }
            /*
            <<< ButtonRow() {
                $0.title = "清除本地缓存"
            }
            */
            
            +++ Section("来源")
            <<< ButtonRow() {
                $0.title = "交路信息：CRH380AL 动车组"
                $0.onCellSelection({ (_, _) in
                    UIApplication.shared.openURL(URL(string: "https://weibo.com/u/2646253421")!)
                })
            }
            <<< ButtonRow() {
                $0.title = "运用信息：Arnie97"
                $0.onCellSelection({ (_, _) in
                    UIApplication.shared.openURL(URL(string: "https://github.com/Arnie97")!)
                })
            }
            +++ Section("其他")
            <<< ButtonRow() {
                $0.title = "开源组件许可证"
                $0.onCellSelection({ (_, _) in
                    self.performSegue(withIdentifier: "showOpenSourceLicense", sender: nil)
                })
            }
            <<< ButtonRow() {
                $0.title = "https://moerail.ml"
                $0.onCellSelection({ (_, _) in
                    let controller = SFSafariViewController(url: URL(string: "https://moerail.ml")!)
                    self.present(controller, animated: true)
                })
            }
            +++ Section("作者")
                    <<< ButtonRow() {
                        $0.title = "hqy2000"
                        $0.onCellSelection({ (_, _) in
                            UIApplication.shared.openURL(URL(string: "https://github.com/hqy2000")!)
                        })
                
        }
    }
}
