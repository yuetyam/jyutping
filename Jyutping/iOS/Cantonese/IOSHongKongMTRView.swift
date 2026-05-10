#if os(iOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct IOSHongKongMTRView: View {

        @State private var lines: [HongKongMTR.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 50)

        var body: some View {
                if #available(iOS 17.0, *) {
                        List {
                                ForEach(lines.indices, id: \.self) { index in
                                        Section {
                                                MTRLineView(line: lines[index], isExpanded: $expanded[index])
                                        }
                                }
                        }
                        .listSectionSpacing(12)
                        .animation(.default, value: expanded)
                        .task {
                                guard lines.isEmpty else { return }
                                lines = HongKongMTR.lines
                        }
                        .navigationTitle("IOSCantoneseTab.NavigationTitle.HongKongMTR")
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                        List {
                                ForEach(lines.indices, id: \.self) { index in
                                        Section {
                                                MTRLineView(line: lines[index], isExpanded: $expanded[index])
                                        }
                                }
                        }
                        .animation(.default, value: expanded)
                        .task {
                                guard lines.isEmpty else { return }
                                lines = HongKongMTR.lines
                        }
                        .navigationTitle("IOSCantoneseTab.NavigationTitle.HongKongMTR")
                        .navigationBarTitleDisplayMode(.inline)
                }
        }
}

private struct MTRLineView: View {
        let line: HongKongMTR.Line
        @Binding var isExpanded: Bool
        var body: some View {
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
                                        .font(.footnote)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .opacity(0.75)
                                Spacer()
                                Image(systemName: isExpanded ? "chevron.down" : "chevron.backward")
                        }
                        .textSelection(.disabled)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if isExpanded {
                        ForEach(line.stations.indices, id: \.self) { index in
                                MTRStationLabel(station: line.stations[index])
                        }
                }
        }
}
private struct MTRStationLabel: View {
        let station: HongKongMTR.Station
        var body: some View {
                HStack {
                        VStack(spacing: 2) {
                                Text(verbatim: station.english)
                                        .font(.footnote)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .opacity(0.75)
                                        .frame(maxWidth: 64)
                                MTRStationIndicatorView(code: station.code, back: station.background, fore: station.foreground)
                        }
                        .padding(.trailing, 4)
                        RubyStackView(text: station.name, romanization: station.romanization)
                        Spacer()
                        Speaker(station.romanization)
                }
        }
}
private struct MTRStationIndicatorView: View {
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
