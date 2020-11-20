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
    @Published var mode: Mode = .empty
    @Published var query = ""
    @Published var showEmptyAlert = false
    @Published var showServerErrorAlert = false
    
    enum Mode {
        case empty
        case singleTrain
        case singleEmu
        case multipleEmus
    }
    
    var groupByDay: [String: [EMU]] {
        return Dictionary(grouping: self.emuList, by: { $0.date })
    }
    
    public func getTrackingRecord(keyword: String) {
        TimetableProvider.shared.cancelAll()
        self.query = keyword
        self.mode = .empty
        if (keyword.trimmingCharacters(in: .whitespaces).isEmpty) {
            self.emuList = []
            self.showEmptyAlert = true
        } else if (keyword.starts(with: "C") && !keyword.starts(with: "CR")) || keyword.starts(with: "G") || keyword.starts(with: "D") {
            self.moerailProvider.request(target: .train(keyword: keyword), type: [EMU].self) { results in
                self.emuList = results
                self.showEmptyAlert = results.isEmpty
                
                for (index, emu) in self.emuList.enumerated() {
                    TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                        if self.emuList.count > index {
                            self.emuList[index].timetable = timetable
                        }
                    }
                }
                self.mode = .singleTrain
            } failure: { (error) in
                self.showEmptyAlert = true
            }
            
        } else {
            self.emuList = []
            self.moerailProvider.request(target: .emu(keyword: keyword), type: [EMU].self) { results in
                self.emuList = results
                self.showEmptyAlert = results.isEmpty
                
                for (index, emu) in self.emuList.enumerated() {
                    if index > 0 && self.emuList[index].emu != self.emuList[index - 1].emu {
                        self.mode = .multipleEmus
                    }
                    TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                        if self.emuList.count > index {
                            self.emuList[index].timetable = timetable
                        }
                    }
                }
                
                if self.mode == .empty {
                    self.mode = .singleEmu
                }
            } failure: { (error) in
                self.mode = .empty
                if let error = error as? NetworkError {
                    if error.code == 503 {
                        // self.showServerErrorAlert = true
                        self.showEmptyAlert = true
                    } else {
                        self.showEmptyAlert = true
                    }
                } else {
                    self.showEmptyAlert = true
                }
                
            }
        }
       
    }
}
