//
//  EmptyView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI
import SFSafeSymbols

struct EmptyView: View {
    @State var query = ""
    @State var showSheet = false
    @State var showSuccess = false
    @State var showActionSheet = false
    @State var isCamera = false
    @EnvironmentObject var moerailData: MoerailData
    
    var body: some View {
        VStack(spacing: 10) {
            switch moerailData.mode {
            case .empty:
                Image(systemSymbol: .tram).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("暂未收录\"\(moerailData.query)\"").foregroundColor(.gray)
                Button("上报相关信息") {
                    self.showActionSheet = true
                }
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
                    self.showSheet = true
                    self.isCamera = true
                },
                .default(Text("从相册中选择")) {
                    self.showSheet = true
                    self.isCamera = false
                },
                .cancel(Text("取消")) {
                    
                }
            ])
        }).sheet(isPresented: $showSheet) {
            if isCamera {
                CodeScannerView(codeTypes: [.qr], simulatedData: "") { result in
                    self.showSheet = false
                    switch result {
                    case .success(let code):
                        moerailData.postTrackingURL(url: code) {
                            self.showSuccess = true
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }}
            } else {
                ImagePickerView(sourceType: .photoLibrary) { image in
                    if let ciImage = CIImage.init(image: image) {
                        var options: [String: Any]
                        let context = CIContext()
                        options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
                        let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
                        if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                            options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
                        } else {
                            options = [CIDetectorImageOrientation: 1]
                        }
                        let features = qrDetector?.features(in: ciImage, options: options)
                        
                        if let features = features, !features.isEmpty {
                            for case let row as CIQRCodeFeature in features {
                                if let message = row.messageString {
                                    moerailData.postTrackingURL(url: message) {
                                        self.showSuccess = true
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        .alert(isPresented: $showSuccess, content: {
            Alert(title: Text("上报成功"), message: Text("感谢您的支持，我们将尽快根据您反馈的信息，更新我们的数据！"), dismissButton: .default(Text("OK")))
        })
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
