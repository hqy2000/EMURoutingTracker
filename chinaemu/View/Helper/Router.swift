//
//  Untitled.swift
//  chinaemu
//
//  Created by Qingyang Hu on 12/14/24.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    static let shared: Router = Router()
}
