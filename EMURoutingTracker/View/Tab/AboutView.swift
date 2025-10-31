//
//  AboutView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 8/8/21.
//

import SwiftUI

struct AboutView: View {
    @State var showOpenSourceLicense: Bool = false
    private let licenseText = LicenseTextProvider.shared.text
    var body: some View {
        List {
            Section(header: Text("关于")) {
                Button(action: {
                    guard let url = URL(string: "https://space.bilibili.com/14289681") else { return }
                    UIApplication.shared.open(url)
                })
                {
                    HStack {
                        Text("联系作者").font(.footnote)
                        Spacer()
                        Text("NJLiner").font(.footnote)
                    }
                }
                
                Button(action: {
                    guard let url = URL(string: "https://rail.re/links/#changelog") else { return }
                    UIApplication.shared.open(url)
                })
                {
                    HStack {
                        Text("数据来源").font(.footnote)
                        Spacer()
                        Text("rail.re").font(.footnote)
                    }
                    
                }
                
                Button(action: {
                    guard let url = URL(string: "https://github.com/hqy2000/EMURoutingTracker") else { return }
                    UIApplication.shared.open(url)
                })
                {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("源代码").font(.footnote).foregroundColor(.blue)
                            Text("欢迎在 GitHub 上加星支持 ⭐️").font(.caption2).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("GitHub").font(.footnote)
                    }
                    
                }
                
                Button(action: {
                    guard let url = URL(string: "https://testflight.apple.com/join/lB9yDHcd") else { return }
                    UIApplication.shared.open(url)
                })
                {
                    HStack {
                        Text("TestFlight").font(.footnote)
                    }
                }
                
                
                Button(action: {
                    showOpenSourceLicense = true
                })
                {
                    HStack {
                        Text("开源组件许可").font(.footnote)
                    }
                    
                }
            }
        }.listStyle(InsetGroupedListStyle())
            .sheet(isPresented: $showOpenSourceLicense, content: {
                ScrollView {
                    Text(licenseText)
                        .padding()
                        .font(.system(.caption, design: .monospaced))
                }
            })
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

private final class LicenseTextProvider {
    static let shared = LicenseTextProvider()
    
    let text: String
    
    private init() {
        if let url = Bundle.main.url(forResource: "OpenSourceLicenses", withExtension: "md"),
           let contents = try? String(contentsOf: url, encoding: .utf8) {
            text = contents
        } else {
            text = "暂时无法加载开源许可信息。"
        }
    }
}
