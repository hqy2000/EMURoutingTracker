//
//  QRView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 1/9/22.
//

import SwiftUI
import SFSafeSymbols
import AVFoundation
import CodeScanner

struct ScanQRCodeButton: View {
    @State var showSheet = false
    @EnvironmentObject var vm: EMUTrainViewModel
    
    var body: some View {
        Button(action: {
            showSheet = true
        }, label: {
           Image(systemName: "qrcode.viewfinder")
        }).scanQrCodeActionSheet(isPresented: $showSheet) { message in
            vm.postTrackingURL(url: message)
        }
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRCodeButton()
    }
}
