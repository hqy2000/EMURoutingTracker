//
//  12306Provider.swift
//  ios
//
//  Created by hqy2000 on 7/14/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation

class CRProvider: AbstractProvider<CRRequest> {
    let stationProvider = StationProvider({_ in})
    var tickets: [TrainTicket] = []
    var schedules: [TrainSchedule] = []
    public func getTrainList(from: String, to: String, date: Date, completion: @escaping () -> Void) {
        self.request(target: .leftTicket(from: from, to: to, date: date), type: TrainTicketsWrapper.self, success: { (list) in
            self.tickets = list.data
            completion()
        })
    }
    
    public func getTrainDetail(withTrainNumber trainNumber: String, date: Date, completion: @escaping () -> Void) {
        self.request(target: .search(train: trainNumber, date: date), type: DataWrapper<String>.self, success: { detail in
            self.getTrainDetail(withTrainNo: detail.value, date: date, completion: completion)
        }, failure: {error in
            debugPrint(error)
        })
    }
    
    public func getTrainDetail(withTrainNo trainNo: String, date: Date, completion: @escaping () -> Void) {
        self.request(target: .queryTrainInfo(train: trainNo, date: date), type: ListWrapper<TrainSchedule>.self, success: { (schedules) in
            self.schedules = schedules.data
            completion()
        })
    }
    
    
    

}
