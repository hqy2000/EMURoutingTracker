import SwiftUI

struct SearchListView: View {
    let stations: [Station]
    let completion: (Station) -> Void
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(_ stations: [Station], completion: @escaping (Station) -> Void) {
        self.stations = stations
        self.completion = completion
    }
    
    var body: some View {
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
                                Text(station.pinyin).font(.system(.caption2, design: .monospaced))
                            }
                            Spacer()
                            Text(station.code).font(.system(.body, design: .monospaced))
                        }
                    }
                }
        }
        .navigationTitle("车站选择")
        .searchable(text: $searchText, placement: UIDevice.current.userInterfaceIdiom == .phone ? .navigationBarDrawer(displayMode: .always) : .automatic, prompt: "站名/拼音/拼音首字母")
    }
}



struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView([Station(name: "南京南", code: "NJN", pinyin: "nanjingnan", abbreviation: "NJN")], completion: { station in
            
        })
        .environment(\.colorScheme, .light)
    }
}
