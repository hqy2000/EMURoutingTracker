//
//  MoerailData.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import SwiftUI
import BackgroundTasks
import UserNotifications

class MoerailData: AbstractData<MoerailRequest>, ObservableObject {
    @Published var emuList = [EMU]()
    @Published var isTrain = true
    @Published var query = ""
    
    var groupedByTime: [String: [EMU]] {
        return Dictionary(grouping: self.emuList, by: { $0.date })
    }
    
    public func startAppRefresh() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
    }
    

    public func getTrackingRecord(keyword: String, completion: @escaping () -> Void) {
        self.query = keyword
        if (keyword.starts(with: "C") && !keyword.starts(with: "CR")) || keyword.starts(with: "G") || keyword.starts(with: "D") {
            self.request(target: .train(keyword: keyword), type: [EMU].self, success: { results in
                self.emuList = results
                completion()
            })
            self.isTrain = true
        } else {
            self.request(target: .emu(keyword: keyword), type: [EMU].self, success: { results in
                
                self.emuList = results
                completion()
                
            })
            self.isTrain = false
        }
       
    }
    
    
    public func getTrackingRecords(keywords: [String]) {
        self.request(target: .trains(keywords: keywords.filter({ (keyword) -> Bool in
            return keyword.starts(with: "G") || keyword.starts(with: "C") ||  keyword.starts(with: "D")
        })), type: [EMU].self, success: { result in
            self.emuList = result
            self.isTrain = true
        })
    }
}

struct MoerailData_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
