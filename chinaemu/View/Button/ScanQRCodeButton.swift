//
//  QRView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 1/9/22.
//

import SwiftUI
import SFSafeSymbols
import AVFoundation
import CodeScanner

struct ScanQRCodeButton: View {
    @State var showSheet = false
    @EnvironmentObject var moerailData: MoerailData
    
    var body: some View {
        Button(action: {
            self.showSheet = true
        }, label: {
           Image(systemName: "qrcode.viewfinder")
        }).scanQrCodeActionSheet(isPresented: $showSheet) { message in
            moerailData.postTrackingURL(url: message)
        }
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRCodeButton()
    }
}
