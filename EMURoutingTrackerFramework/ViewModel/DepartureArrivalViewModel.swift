//
//  DepartureArrivalViewModel.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import SwiftUI
import Cache
import RxSwift

class DepartureArrivalViewModel: ObservableObject {
    let crProvider =  AbstractProvider<CRRequest>()
    let moeRailProvider = AbstractProvider<MoerailRequest>()
    private let disposeBag = DisposeBag()
    @Published var isLoading = true
    @Published var departureArrivals: [DepartureArrivalV2] = []
    @Published var emuTrainAssocs: [EMUTrainAssociation] = []
    
    public func getLeftTickets(from: String, to: String, date: Date) {
        crProvider.request(target: .leftTicketPrice(from: from, to: to, date: DateFormatter.standard.string(from: date)), type: CRResponse<[DepartureArrivalV2]>.self)
            .map { $0.data }
            .flatMap { departureArrivals -> Single<[EMUTrainAssociation]> in
                self.departureArrivals = departureArrivals
                let trainNumbers = departureArrivals.map { $0.v1.trainNo }
                return self.moeRailProvider.request(target: .trains(keywords: trainNumbers), type: [EMUTrainAssociation].self)
            }
            .subscribe(onSuccess: { [weak self] emus in
                self?.emuTrainAssocs = emus
                self?.isLoading = false
            }, onFailure: { [weak self] error in
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
}
