#if os(macOS)

import SwiftUI
import Materials

struct MacCantonMetroView: View {

        @State private var lines: [CantonMetro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HeaderTermView(term: Term(name: "廣州地鐵", romanization: "gwong2 zau1 dei6 tit3")).block()
                                ForEach(0..<lines.count, id: \.self) { index in
                                        MacCantonMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                        .animation(.default, value: expanded)
                        .font(.master)
                        .textSelection(.enabled)
                        .padding()
                        .task {
                                guard lines.isEmpty else { return }
                                lines = CantonMetro.lines
                        }
                }
                .navigationTitle("Canton Metro")
        }
}

private struct MacCantonMetroLineView: View {

        let line: CantonMetro.Line
        @Binding var isExpanded: Bool

        var body: some View {
                if isExpanded {
                        VStack(alignment: .leading) {
                                HStack {
                                        Text(verbatim: line.name)
                                        Spacer()
                                        Image(systemName: isExpanded ? "chevron.down" : "chevron.backward")
                                }
                                .textSelection(.disabled)
                                .padding(.bottom)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        isExpanded.toggle()
                                }
                                ForEach(0..<line.stations.count, id: \.self) { index in
                                        let station = line.stations[index]
                                        let placeholder = line.longest ?? station
                                        MacStationLabel(station: station, placeholder: placeholder)
                                }
                        }
                        .block()
                } else {
                        HStack {
                                Text(verbatim: line.name)
                                Spacer()
                                Image(systemName: isExpanded ? "chevron.down" : "chevron.backward")
                        }
                        .textSelection(.disabled)
                        .block()
                        .contentShape(Rectangle())
                        .onTapGesture {
                                isExpanded.toggle()
                        }
                }
        }
}

private struct MacStationLabel: View {

        let station: CantonMetro.Station
        let placeholder: CantonMetro.Station

        var body: some View {
                HStack(spacing: 24) {
                        ZStack(alignment: .leading) {
                                Text(verbatim: placeholder.name).hidden()
                                Text(verbatim: station.name)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: placeholder.romanization).font(.fixedWidth).hidden()
                                Text(verbatim: station.romanization).font(.fixedWidth)
                        }
                        Speaker(station.romanization)
                }
        }
}

#endif
