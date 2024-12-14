//
//  ReportButton.swift
//  chinaemu
//
//  Created by Qingyang Hu on 12/14/24.
//

import SwiftUI
import PhotosUI
import AVFoundation
import CodeScanner

struct QRCodeActionSheet: ViewModifier {
    @Binding var showActionSheet: Bool
    @State var showResultAlert: Bool = false
    @State var reportResult: String? = nil
    var postTrackingURL: (String) -> Void
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showActionSheet) {
                CodeScannerView(codeTypes: [.qr], manualSelect: true, simulatedData: "") { result in
                    showActionSheet = false
                    switch result {
                    case .success(let code):
                        postTrackingURL(code.string)
                        reportResult = nil
                    case .failure(let error):
                        reportResult = error.localizedDescription
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showResultAlert = true
                    }
                }
            }
            .alert(isPresented: $showResultAlert, content: {
                Alert(title: Text(self.reportResult == nil ? "上报成功" : "上报失败"), message: Text(self.reportResult ?? "感谢您的支持，我们将尽快根据您反馈的信息，更新我们的数据！"), dismissButton: .default(Text("好的")))
            })
    }
}

extension View {
    func qrCodeActionSheet(
        showActionSheet: Binding<Bool>,
        postTrackingURL: @escaping (String) -> Void
    ) -> some View {
        self.modifier(QRCodeActionSheet(
            showActionSheet: showActionSheet,
            postTrackingURL: postTrackingURL
        ))
    }
}
