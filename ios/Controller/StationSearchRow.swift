//
//  StationSearchPresenterRowType.swift
//  ios
//
//  Created by hqy2000 on 7/10/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Eureka
import UIKit

internal final class StationSearchRow: SelectorRow<PushSelectorCell<Station>>, RowType {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        self.displayValueFor = { station in
            if let station = station {
                return station.name
            } else {
                return ""
            }
        }
        presentationMode = .segueName(segueName: "showStationSearchController", onDismiss: nil)
    }
    
    override public func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        if let viewController = segue.destination as? StationSearchController {
            viewController.onDismissCallback = { vc in
                vc.navigationController?.popViewController(animated: true)
                if let vc = vc as? StationSearchController {
                    if let station = vc.selected {
                        self.value = station
                    }
                }
                
            }
        }
    }
    
}
