//
//  AboutView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 8/8/21.
//

import SwiftUI

struct AboutView: View {
    @State var showOpenSourceLicense: Bool = false
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
                    Text(
                """
                ----------------------------
                https://github.com/hyperoslo/Cache
                
                Copyright (c) 2015 Hyper Interaktiv AS
                
                Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
                
                The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
                
                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                
                ----------------------------
                https://github.com/sunshinejr/SwiftyUserDefaults
                
                Copyright (c) 2015-present Radosław Pietruszewski, Łukasz Mróz
                
                Permission is hereby granted, free of charge, to any person obtaining a copy
                of this software and associated documentation files (the "Software"), to deal
                in the Software without restriction, including without limitation the rights
                to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                copies of the Software, and to permit persons to whom the Software is
                furnished to do so, subject to the following conditions:
                
                The above copyright notice and this permission notice shall be included in all
                copies or substantial portions of the Software.
                
                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                SOFTWARE.
                
                
                ----------------------------
                https://github.com/getsentry/sentry-cocoa
                
                Copyright (c) 2015 Sentry
                
                Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
                
                The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
                
                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                
                -----------------------
                https://github.com/Moya/Moya
                
                Copyright (c) 2014-present Artsy, Ash Furrow
                
                Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
                
                The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
                
                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                
                -----------------------
                https://github.com/twostraws/CodeScanner
                
                Copyright (c) 2019 Paul Hudson
                
                Permission is hereby granted, free of charge, to any person obtaining a copy
                of this software and associated documentation files (the "Software"), to deal
                in the Software without restriction, including without limitation the rights
                to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                copies of the Software, and to permit persons to whom the Software is
                furnished to do so, subject to the following conditions:
                
                The above copyright notice and this permission notice shall be included in all
                copies or substantial portions of the Software.
                
                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                SOFTWARE.
                """).padding().font(.system(.caption, design: .monospaced))
                }
            })
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
