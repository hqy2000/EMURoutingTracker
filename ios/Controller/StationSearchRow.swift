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

public final class CustomPushRow<T: Equatable>: SelectorRow<PushSelectorCell<T>>, RowType {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .show(controllerProvider: ControllerProvider.callback {
            return StationSearchController(){ _ in }
            }, onDismiss: { vc in
                _ = vc.navigationController?.popViewController(animated: true)
        })
    }
    
}
