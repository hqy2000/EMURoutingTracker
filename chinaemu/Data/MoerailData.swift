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

class MoerailData: ObservableObject {
    let moerailProvider = AbstractProvider<MoerailRequest>();
    let crProvider = AbstractProvider<CRRequest>();
    
    @Published var emuList = [EMU]()
    @Published var mode: Mode = .loading
    @Published var query = ""
    
    enum Mode {
        case loading
        case singleTrain
        case singleEmu
        case multipleEmus
    }
    
    var groupByDay: [String: [EMU]] {
        return Dictionary(grouping: self.emuList, by: { $0.date })
    }
    
//    var groupByWeek: [String: [EMU]] {
//
//    }

    public func getTrackingRecord(keyword: String) {
        self.query = keyword
        if (keyword.starts(with: "C") && !keyword.starts(with: "CR")) || keyword.starts(with: "G") || keyword.starts(with: "D") {
            self.moerailProvider.request(target: .train(keyword: keyword), type: [EMU].self, success: { results in
                self.emuList = results
                for (index, emu) in self.emuList.enumerated() {
                    TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                        self.emuList[index].timetable = timetable
                    }
                }
                self.mode = .singleTrain
            })
            
        } else {
            self.moerailProvider.request(target: .emu(keyword: keyword), type: [EMU].self, success: { results in
                self.emuList = results
                
                for (index, emu) in self.emuList.enumerated() {
                    if index > 0 && self.emuList[index].emu != self.emuList[index - 1].emu {
                        self.mode = .multipleEmus
                    }
                    TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                        self.emuList[index].timetable = timetable
                    }
                }
                
                if self.mode == .loading {
                    self.mode = .singleEmu
                }
            })
        }
       
    }
}
