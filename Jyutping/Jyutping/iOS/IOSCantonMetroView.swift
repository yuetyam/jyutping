#if os(iOS)

import SwiftUI
import Materials

struct IOSCantonMetroView: View {

        @State private var lines: [CantonMetro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                List {
                        Section {
                                HeaderTermView(term: Term(name: "廣州地鐵", romanization: "gwong2 zau1 dei6 tit3"))
                        }
                        ForEach(0..<lines.count, id: \.self) { index in
                                Section {
                                        IOSCantonMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                }
                .animation(.default, value: expanded)
                .textSelection(.enabled)
                .task {
                        guard lines.isEmpty else { return }
                        lines = CantonMetro.lines
                }
                .navigationTitle("Canton Metro")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private struct IOSCantonMetroLineView: View {

        let line: CantonMetro.Line
        @Binding var isExpanded: Bool

        var body: some View {
                HStack {
                        Text(verbatim: line.name)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.backward")
                }
                .textSelection(.disabled)
                .contentShape(Rectangle())
                .onTapGesture {
                        isExpanded.toggle()
                }
                if isExpanded {
                        ForEach(0..<line.stations.count, id: \.self) { index in
                                IOSStationLabel(station: line.stations[index])
                        }
                }
        }
}

private struct IOSStationLabel: View {

        let station: CantonMetro.Station

        var body: some View {
                HStack {
                        HStack(spacing: 12) {
                                Text(verbatim: station.name)
                                Text(verbatim: station.romanization)
                                        .font(.copilot)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                        }
                        Spacer()
                        Speaker(station.romanization)
                }
        }
}

#endif
