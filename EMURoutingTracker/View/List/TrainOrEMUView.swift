//
//  MoerailView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/8/20.
//

import SwiftUI

struct TrainOrEMUView: View {
    @ObservedObject var vm = EMUTrainViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let query: String
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            switch vm.mode {
            case .singleEmu:
                SingleEMUList(path: $path).environmentObject(vm)
            case .singleTrain:
                TrainList(path: $path).environmentObject(vm)
            case .multipleEmus:
                MultipleEMUList(path: $path).environmentObject(vm)
            default:
                EmptyRow(path: $path).environmentObject(vm)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            if vm.mode == .loading {
                vm.getTrackingRecord(keyword: query)
            }
        })
        .navigationTitle(query)
    }
}

struct MoerailView_Previews: PreviewProvider {
    static var previews: some View {
        TrainOrEMUView(query: "380", path: Binding.constant(NavigationPath()))
    }
}
