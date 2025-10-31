import SwiftUI

struct StationPicker: View {
    let stations: [Station]
    let completion: (Station) -> Void
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    init(_ stations: [Station], completion: @escaping (Station) -> Void) {
        self.stations = stations
        self.completion = completion
    }
    
    var body: some View {
        List {
            ForEach(filteredStations, id: \.code) { station in
                Button {
                    completion(station)
                    dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(station.name)
                            Text(station.pinyin)
                                .font(.system(.caption2, design: .monospaced))
                        }
                        Spacer()
                        Text(station.code)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }
        }
        .navigationTitle("车站选择")
        .searchable(
            text: $searchText,
            placement: UIDevice.current.userInterfaceIdiom == .phone ? .navigationBarDrawer(displayMode: .always) : .automatic,
            prompt: "站名/拼音/拼音首字母"
        )
    }
    
    private var filteredStations: [Station] {
        let trimmed = searchText.replacingOccurrences(of: " ", with: "")
        guard !trimmed.isEmpty else { return stations }
        let lowercase = trimmed.lowercased()
        let uppercase = trimmed.uppercased()
        
        return stations.filter { station in
            station.name.contains(trimmed)
            || station.pinyin.contains(lowercase)
            || station.abbreviation.contains(lowercase)
            || station.code.contains(uppercase)
        }
    }
}



struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        StationPicker([Station(name: "南京南", code: "NJN", pinyin: "nanjingnan", abbreviation: "NJN")], completion: { station in
            
        })
        .environment(\.colorScheme, .light)
    }
}
