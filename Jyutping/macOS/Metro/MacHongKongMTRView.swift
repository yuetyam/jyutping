#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacHongKongMTRView: View {

        @State private var lines: [HongKongMTR.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 8) {
                                ForEach(lines.indices, id: \.self) { index in
                                        MacMTRLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                        .animation(.default, value: expanded)
                        .padding()
                        .task {
                                guard lines.isEmpty else { return }
                                lines = HongKongMTR.lines
                        }
                }
                .navigationTitle("MacSidebar.NavigationTitle.HongKongMTR")
        }
}

private struct MacMTRLineView: View {
        let line: HongKongMTR.Line
        @Binding var isExpanded: Bool
        var body: some View {
                if isExpanded {
                        VStack(alignment: .leading) {
                                Button {
                                        isExpanded.toggle()
                                } label: {
                                        HStack {
                                                Text(verbatim: line.name)
                                                        .font(.display)
                                                        .padding(.vertical, 4)
                                                        .padding(.horizontal, 12)
                                                        .foregroundStyle(Color.white)
                                                        .background(Color(rgb: line.color), in: .capsule)
                                                Text(verbatim: line.english)
                                                        .font(.body)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                        .opacity(0.8)
                                                Spacer()
                                                Image(systemName: isExpanded ? "chevron.down" : "chevron.backward")
                                        }
                                        .textSelection(.disabled)
                                        .padding(.vertical, 8)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                VStack(alignment: .leading) {
                                        ForEach(line.stations.indices, id: \.self) { index in
                                                Divider()
                                                MacMTRStationLabel(station: line.stations[index])
                                        }
                                }
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        .stack()
                } else {
                        Button {
                                isExpanded.toggle()
                        } label: {
                                HStack {
                                        Text(verbatim: line.name)
                                                .font(.display)
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 12)
                                                .foregroundStyle(Color.white)
                                                .background(Color(rgb: line.color), in: .capsule)
                                        Text(verbatim: line.english)
                                                .font(.body)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .opacity(0.8)
                                        Spacer()
                                        Image(systemName: isExpanded ? "chevron.down" : "chevron.backward")
                                }
                                .textSelection(.disabled)
                                .block()
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                }
        }
}
private struct MacMTRStationLabel: View {
        let station: HongKongMTR.Station
        var body: some View {
                HStack {
                        VStack(spacing: 2) {
                                Text(verbatim: station.english)
                                        .font(.body)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .opacity(0.75)
                                        .frame(maxWidth: 64)
                                MacMTRStationIndicatorView(code: station.code, back: station.background, fore: station.foreground)
                        }
                        .padding(.trailing, 4)
                        RubyStackView(text: station.name, romanization: station.romanization)
                        Spacer()
                        Speaker(station.romanization)
                }
        }
}
private struct MacMTRStationIndicatorView: View {
        let code: String
        let back: UInt32
        let fore: UInt32
        var body: some View {
                ZStack {
                        Color(rgb: back).clipShape(.capsule)
                        Text(verbatim: code)
                                .font(.system(size: 13, weight: .medium, design: .monospaced))
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .foregroundStyle(Color(rgb: fore))
                                .padding(4)
                }
                .frame(width: 48)
        }
}

#endif
