//
//  TrainTicketCell.swift
//  Moerail
//
//  Created by Qingyang Hu on 10/9/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class TrainTicketCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var train: UILabel!
    @IBOutlet weak var emu: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startStation: UILabel!
    @IBOutlet weak var endStation: UILabel!
    @IBOutlet weak var ticketStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.emu.layer.cornerRadius = 3
        self.emu.layer.backgroundColor = UIColor.blue.cgColor
        self.emu.layer.masksToBounds = true
        self.emu.adjustsFontSizeToFitWidth = true
        self.emu.minimumScaleFactor = 0.2
    }
    
    public func setEmu(_ emu: String) {
        if emu.starts(with: "CR400A") {
            self.emu.layer.backgroundColor = UIColor(red: 238.0/255.0, green: 0.0/255.0, blue: 18.0/255.0, alpha: 1).cgColor
        } else if emu.starts(with: "CR400B") {
            self.emu.layer.backgroundColor = UIColor(red: 161.0/255.0, green: 110.0/255.0, blue: 37.0/255.0, alpha: 1).cgColor
        } else if emu.starts(with: "CR200") {
            self.emu.layer.backgroundColor = UIColor(red: 42.0/255.0, green: 163.0/255.0, blue: 50.0/255.0, alpha: 1).cgColor
        } else if emu.starts(with: "MTR"){
            self.emu.layer.backgroundColor = UIColor(red: 196.0/255.0, green: 30.0/255.0, blue: 58.0/255.0, alpha: 1).cgColor
        } else {
            self.emu.layer.backgroundColor = UIColor(red: 30.0/255.0, green: 58.0/255.0, blue: 145.0/255.0, alpha: 1).cgColor
        }
        
        self.emu.text = " " + emu + " "
        self.logo.image = TrainTicketCell.getImage(emu)
    }
    
    public static func getImage(_ fullEmu: String) -> UIImage? {
        let emu = fullEmu.replacingOccurrences(of: "新", with: "")
        var filename = ""
        switch emu {
        case _ where emu.starts(with: "CR400A"):
            filename = "cn-cr400a"
        case _ where emu.starts(with: "CR400B"):
            filename = "cn-cr400b"
        case _ where emu.starts(with: "CR200J"):
            filename = "cn-cr200j"
        case _ where emu.starts(with: "CRH1E"):
            filename = "cn-crh1e"
        case _ where emu.starts(with: "CRH1"):
            filename = "cn-crh1"
        case _ where emu.starts(with: "CRH2B"):
            filename = "cn-crh2b"
        case _ where emu.starts(with: "CRH2C"):
            filename = "cn-crh2c"
        case _ where emu.starts(with: "CRH2G"),
             _ where emu.starts(with: "CRH2H"):
            filename = "cn-crh2g"
        case _ where emu.starts(with: "CRH2"):
            filename = "cn-crh2"
        case _ where emu.starts(with: "CRH380B"):
            filename = "cn-crh380b"
        case _ where emu.starts(with: "CRH380C"):
            filename = "cn-crh380c"
        case _ where emu.starts(with: "CRH380D"):
            filename = "cn-crh380d"
        case _ where emu.starts(with: "CRH380"):
            filename = "cn-crh380"
        case _ where emu.starts(with: "CRH3A"):
            filename = "cn-crh3a"
        case _ where emu.starts(with: "CRH3"):
            filename = "cn-crh3"
        case _ where emu.starts(with: "CRH5"):
            filename = "cn-crh5"
        case _ where emu.starts(with: "CRH6F"):
            filename = "cn-crh6f"
        case _ where emu.starts(with: "CRH6"):
            filename = "cn-crh6"
        case _ where emu.starts(with: "MTR"):
            filename = "hk-mtr380a"
        default:
            filename = "cn-hxn5"
        }
        
        let image = UIImage(named: filename + ".png")
        
        if emu.contains("重联") {
            return UIImage(named: filename + "_.png") ?? image
        } else {
            return image
        }
    }
}
