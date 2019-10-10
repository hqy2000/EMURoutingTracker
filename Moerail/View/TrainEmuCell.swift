//
//  TrainEmuCell.swift
//  ios
//
//  Created by Qingyang Hu on 10/8/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import UIKit

class TrainEmuCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var remark: UILabel!
    
    public func setLogo(emu: String) {
        self.logo.image = TrainTicketCell.getImage(emu)
    }
}
