//
//  MoerailProvider.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/11/20.
//

import Foundation
import Cache

internal class StationProvider: AbstractProvider<CRRequest> {
    public static let shared = StationProvider()
    private let stations: [Station] = []
    
    override private init() {
        super.init()
        self.get()
    }

    internal func get() {
        self.request(target: .stations, type: String.self) { (result) in
            print(result)
        }
    }
}
