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
    
    public func getTrainList(from: String, to: String, date: Date, completion: @escaping (String?) -> Void) {
        self.tickets = []
        self.request(target: .leftTicket(from: from, to: to, date: date), type: ListWrapper<TrainTicket>.self, success: { (list) in
            self.tickets = list.data
            completion(nil)
        }, failure: {error in
            completion(error.localizedDescription)
        })
    }
    
    public func getTrainDetail(withTrainNumber trainNumber: String, date: Date, completion: @escaping (String?) -> Void) {
        self.schedules = []
        self.request(target: .queryByTrainNumber(train: trainNumber, date: date), type: ListWrapper<TrainSchedule>.self, success: { schedules in
            self.schedules = schedules.data
            completion(nil)
        }, failure: {error in
            completion(error.localizedDescription)
        })
    }
    
    /*
    public func getTrainDetail(withTrainNo trainNo: String, date: Date, completion: @escaping (String?) -> Void) {
        self.schedules = []
        self.request(target: .queryByTrainNo(train: trainNo, date: date), type: ListWrapper<TrainSchedule>.self, success: { (schedules) in
            self.schedules = schedules.data
            completion(nil)
        }, failure: {error in
            completion(error.localizedDescription)
        })
    }
 */
}
