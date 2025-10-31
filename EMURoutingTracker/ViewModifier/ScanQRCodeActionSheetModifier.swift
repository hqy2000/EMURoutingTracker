//
//  ReportButton.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 12/14/24.
//

import SwiftUI
import AVFoundation
import CodeScanner
import Sentry

struct ScanQRCodeActionSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State private var outcome: ScanOutcome?
    var onCompletion: (String) -> Void
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                CodeScannerView(codeTypes: [.qr], manualSelect: true, simulatedData: "") { result in
                    isPresented = false
                    let newOutcome: ScanOutcome
                    switch result {
                    case .success(let code):
                        onCompletion(code.string)
                        newOutcome = ScanOutcome.success()
                    case .failure(let error):
                        SentrySDK.capture(error: error)
                        let message: String
                        if case .permissionDenied = error {
                            message = "您没有开启相机权限，请至 系统设置 - 隐私 中开启。"
                        } else {
                            message = error.localizedDescription + "请确认您扫描的二维码为点餐码。"
                        }
                        newOutcome = ScanOutcome.failure(message: message)
                    }
                    DispatchQueue.main.async {
                        outcome = newOutcome
                    }
                }
            }
            .alert(item: $outcome) { outcome in
                Alert(
                    title: Text(outcome.title),
                    message: Text(outcome.message),
                    dismissButton: .default(Text("好的"))
                )
            }
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

private struct ScanOutcome: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    
    static func success() -> ScanOutcome {
        ScanOutcome(
            title: "上报成功",
            message: "感谢您的支持，我们将尽快根据您反馈的信息，更新我们的数据！"
        )
    }
    
    static func failure(message: String) -> ScanOutcome {
        ScanOutcome(
            title: "上报失败",
            message: message
        )
    }
}
