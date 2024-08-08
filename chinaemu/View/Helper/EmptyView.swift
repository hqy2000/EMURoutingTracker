//
//  EmptyView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI
import SFSafeSymbols
import AVFoundation
import CodeScanner

struct EmptyView: View {
    @State var query = ""
    @State var showSheet = false
    @State var showResultAlert = false
    @State var showActionSheet = false
    @State var reportResult: String? = nil
    @State var isCamera = false
    @EnvironmentObject var moerailData: MoerailData
    
    var body: some View {
        VStack(spacing: 10) {
            switch moerailData.mode {
            case .emptyEmu:
                Image(systemSymbol: .tram).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("暂未收录\"\(moerailData.query)\"").foregroundColor(.gray)
                Button("上报相关信息") {
                    self.showActionSheet = true
                }
            case .emptyTrain:
                Image(systemSymbol: .tram).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("暂未收录\"\(moerailData.query)\"\n可尝试搜索相关车组号").foregroundColor(.gray).multilineTextAlignment(.center)
            case .error:
                Image(systemSymbol: .multiply).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text(moerailData.errorMessage).foregroundColor(.gray)
            default:
                Image(systemSymbol: .magnifyingglass).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("加载中")
            }


        }.actionSheet(isPresented: $showActionSheet, content: {
            ActionSheet(title: Text("请上传对应列车内的点餐二维码"), buttons: [
                .default(Text("扫描二维码")) {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                            if response {
                                self.showSheet = true
                                self.isCamera = true
                            } else {
                                self.reportResult = "您没有开启相机权限，请至 系统设置 - 隐私 中开启。"
                                self.showResultAlert = true
                            }
                        }
                  
                },
                .default(Text("从相册中选择")) {
                    
                    self.showSheet = true
                    self.isCamera = false
                },
                .cancel(Text("取消")) {
                    
                }
            ])
        }).sheet(isPresented: $showSheet) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "") { result in
                self.showSheet = false
                switch result {
                case .success(let code):
                    moerailData.postTrackingURL(url: code.string) {
                        self.showResultAlert = true
                        self.reportResult = nil
                    }
                case .failure(let error):
                    self.showResultAlert = true
                    self.reportResult = error.localizedDescription
            }}
//            
//                if isCamera {
//                    
//                } else {
//                    ImagePickerView(sourceType: .photoLibrary) { image in
//                        if let ciImage = CIImage.init(image: image) {
//                            var options: [String: Any]
//                            let context = CIContext()
//                            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
//                            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
//                            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
//                                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
//                            } else {
//                                options = [CIDetectorImageOrientation: 1]
//                            }
//                            let features = qrDetector?.features(in: ciImage, options: options)
//                            
//                            if let features = features, !features.isEmpty {
//                                for case let row as CIQRCodeFeature in features {
//                                    if let message = row.messageString {
//                                        moerailData.postTrackingURL(url: message) {
//                                            self.reportResult =  nil
//                                            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
//                                                self.showResultAlert = true
//                                            }
//                                        }
//                                    }
//                                }
//                            } else {
//                                self.reportResult = "未能识别到二维码，请重新选择照片。"
//                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
//                                    self.showResultAlert = true
//                                }
//                            }
//                            
//                            
//                        }
//                        
//                    }
//                }
        }
        .alert(isPresented: $showResultAlert, content: {
            Alert(title: Text(self.reportResult == nil ? "上报成功" : "上报失败"), message: Text(self.reportResult ?? "感谢您的支持，我们将尽快根据您反馈的信息，更新我们的数据！"), dismissButton: .default(Text("好的")))
        })
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
