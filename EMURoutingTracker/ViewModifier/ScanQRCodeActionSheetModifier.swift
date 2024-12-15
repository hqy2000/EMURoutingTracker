//
//  ReportButton.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 12/14/24.
//

import SwiftUI
import PhotosUI
import AVFoundation
import CodeScanner

struct ScanQRCodeActionSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State var showAlert: Bool = false
    @State var result: String? = nil
    var onCompletion: (String) -> Void
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                CodeScannerView(codeTypes: [.qr], manualSelect: true, simulatedData: "") { result in
                    isPresented = false
                    switch result {
                    case .success(let code):
                        self.onCompletion(code.string)
                        self.result = nil
                    case .failure(let error):
                        self.result = error.localizedDescription
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.showAlert = true
                    }
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(self.result == nil ? "上报成功" : "上报失败"), message: Text(self.result ?? "感谢您的支持，我们将尽快根据您反馈的信息，更新我们的数据！"), dismissButton: .default(Text("好的")))
            })
    }
}

extension View {
    func scanQrCodeActionSheet(
        isPresented: Binding<Bool>,
        onCompletion: @escaping (String) -> Void
    ) -> some View {
        self.modifier(ScanQRCodeActionSheetModifier(
            isPresented: isPresented,
            onCompletion: onCompletion
        ))
    }
}
