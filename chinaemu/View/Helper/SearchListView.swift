import SwiftUI

struct SearchListView: View {
    let stations: [Station]
    let completion: (Station) -> Void
    @State private var searchText = ""
    @State private var title = "车站选择"
    @State private var showCancelButton: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(_ stations: [Station], completion: @escaping (Station) -> Void) {
        self.stations = stations
        self.completion = completion
    }

    var body: some View {
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("站名/拼音/拼音首字母", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)

                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if showCancelButton  {
                        Button("Cancel") {
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.searchText = ""
                                self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly

                List {
                    ForEach(stations.filter{
                                $0.name.contains(searchText.replacingOccurrences(of: " ", with: "")) ||
                                    $0.pinyin.contains(searchText.replacingOccurrences(of: " ", with: "").lowercased()) ||
                                    $0.abbreviation.contains(searchText.replacingOccurrences(of: " ", with: "").lowercased()) ||
                                    $0.code.contains(searchText.replacingOccurrences(of: " ", with: "").uppercased()) ||
                                    searchText == ""}, id: \.code) { station in
                        Button(action: {
                            self.completion(station)
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(station.name)
                                    Text(station.pinyin).font(.caption2)
                                }
                                Spacer()
                                Text(station.code).font(.system(.body, design: .monospaced))
                            }
                        }
                    }
                }
                .navigationBarTitle(Text(self.title))
                .resignKeyboardOnDragGesture()
            }
        }
}



struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView([Station(name: "南京南", code: "NJN", pinyin: "nanjingnan", abbreviation: "NJN")], completion: { station in
            print(station.code)
        })
           .environment(\.colorScheme, .light)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
