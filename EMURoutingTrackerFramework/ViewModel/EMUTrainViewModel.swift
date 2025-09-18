//
//  MoerailData.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import SwiftUI
import BackgroundTasks
import UserNotifications
import RxSwift

class EMUTrainViewModel: ObservableObject {
    let moerailProvider = AbstractProvider<MoerailRequest>()
    private let disposeBag = DisposeBag()
    
    @Published var emuTrainAssocList = [EMUTrainAssociation]()
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
    
    var groupedByDay: [String: [EMUTrainAssociation]] {
        return Dictionary(grouping: emuTrainAssocList, by: { $0.date })
    }
    
    public func postTrackingURL(url: String, completion: (() -> Void)? = nil) {
        guard !url.isEmpty else { return }
        moerailProvider.request(target: .qr(emu: query, url: url), type: [EMUTrainAssociation].self)
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                debugPrint(url)
            })
            .disposed(by: disposeBag)
    }
    
    public func getTrackingRecord(keyword: String) {
        TrainInfoProvider.shared.cancelAll()
        query = keyword
        mode = .loading
        if (keyword.trimmingCharacters(in: .whitespaces).isEmpty) {
            emuTrainAssocList = []
            mode = .emptyTrain
        } else if (keyword.starts(with: "C") && !keyword.starts(with: "CR")) || keyword.starts(with: "G") || keyword.starts(with: "D") {
            moerailProvider.request(target: .train(keyword: keyword), type: [EMUTrainAssociation].self)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] results in
                    self?.emuTrainAssocList = results
                    for (index, emu) in results.enumerated() {
                        TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { (trainInfo) in
                            if let emuTrainAssocList = self?.emuTrainAssocList, emuTrainAssocList.count > index {
                                self?.emuTrainAssocList[index].trainInfo = trainInfo
                            }
                        }
                    }
                    
                    if self?.emuTrainAssocList.isEmpty ?? true {
                        self?.mode = .emptyTrain
                    } else {
                        self?.mode = .singleTrain
                    }
                }, onFailure: { [weak self] error in
                    self?.handleError(error)
                }).disposed(by: disposeBag)
            
        } else {
            emuTrainAssocList = []
            moerailProvider.request(target: .emu(keyword: keyword), type: [EMUTrainAssociation].self)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] results in
                    self?.emuTrainAssocList = results
                    
                    for (index, emu) in results.enumerated() {
                        if index > 0 && self?.emuTrainAssocList[index].emu != self?.emuTrainAssocList[index - 1].emu {
                            self?.mode = .multipleEmus
                        }
                        TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { (trainInfo) in
                            if let emuTrainAssocList = self?.emuTrainAssocList, emuTrainAssocList.count > index {
                                self?.emuTrainAssocList[index].trainInfo = trainInfo
                            }
                        }
                    }
                    
                    if self?.emuTrainAssocList.isEmpty ?? true {
                        self?.mode = .emptyEmu
                    } else if self?.mode == .loading {
                        self?.mode = .singleEmu
                    }
                }, onFailure: { [weak self] error in
                    self?.handleError(error)
                }).disposed(by: disposeBag)
        }
    }
    
    public func handleError(_ error: Error) {
        mode = .error
        if let error = error as? NetworkError {
            if error.code == 503 {
                errorMessage = "服务暂时不可用，请稍后再试"
            } else if error.code == 404 {
                errorMessage = "\"\(query)\"不是一个正确的车次或车组。"
            } else {
                errorMessage = error.localizedDescription
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
    
}
