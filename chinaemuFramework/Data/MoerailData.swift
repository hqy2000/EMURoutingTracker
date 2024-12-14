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
    @Published var errorMessage = ""

    enum Mode {
        case loading
        case emptyTrain
        case emptyEmu
        case error
        case singleTrain
        case singleEmu
        case multipleEmus
    }
    
    var groupByDay: [String: [EMU]] {
        return Dictionary(grouping: self.emuList, by: { $0.date })
    }
    
    public func postTrackingURL(url: String, completion: (() -> Void)? = nil) {
        self.moerailProvider.request(target: .qr(emu: self.query, url: url), type: [EMU].self) { (results) in
            print(url)
            completion?()
        }
    }
    
    public func getTrackingRecord(keyword: String) {
        TrainInfoProvider.shared.cancelAll()
        self.query = keyword
        self.mode = .loading
        if (keyword.trimmingCharacters(in: .whitespaces).isEmpty) {
            self.emuList = []
            self.mode = .emptyTrain
        } else if (keyword.starts(with: "C") && !keyword.starts(with: "CR")) || keyword.starts(with: "G") || keyword.starts(with: "D") {
            self.moerailProvider.request(target: .train(keyword: keyword), type: [EMU].self) { results in
                self.emuList = results
                for (index, emu) in self.emuList.enumerated() {
                    TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { (trainInfo) in
                        if self.emuList.count > index {
                            self.emuList[index].trainInfo = trainInfo
                        }
                    }
                }
                
                if self.emuList.isEmpty {
                    self.mode = .emptyTrain
                } else {
                    self.mode = .singleTrain
                }
            } failure: { (error) in
                self.handleError(error)
            }
            
        } else {
            self.emuList = []
            self.moerailProvider.request(target: .emu(keyword: keyword), type: [EMU].self) { results in
                self.emuList = results
                
                for (index, emu) in self.emuList.enumerated() {
                    if index > 0 && self.emuList[index].emu != self.emuList[index - 1].emu {
                        self.mode = .multipleEmus
                    }
                    TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { (trainInfo) in
                        if self.emuList.count > index {
                            self.emuList[index].trainInfo = trainInfo
                        }
                    }
                }
                
                if self.emuList.isEmpty {
                    self.mode = .emptyEmu
                } else if self.mode == .loading {
                    self.mode = .singleEmu
                }
            } failure: { (error) in
                self.handleError(error)
            }
        }
    }
    
    public func handleError(_ error: Error) {
        self.mode = .error
        if let error = error as? NetworkError {
            if error.code == 503 {
                self.errorMessage = "服务暂时不可用，请稍后再试"
            } else if error.code == 404 {
                self.errorMessage = "\"\(query)\"不是一个正确的车次或车组。"
            } else {
                self.errorMessage = error.localizedDescription
            }
        } else {
            self.errorMessage = error.localizedDescription
        }
    }
       
}
