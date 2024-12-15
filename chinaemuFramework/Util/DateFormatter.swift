//
//  DateFormatter.swift
//  chinaemu
//
//  Created by Qingyang Hu on 12/14/24.
//

import Foundation

extension DateFormatter {
    static var standard: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
