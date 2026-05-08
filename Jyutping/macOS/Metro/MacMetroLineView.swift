#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacMetroLineView: View {

        let line: Metro.Line
        @Binding var isExpanded: Bool

        var body: some View {
                let indicatingColor = line.backgroundColor
                let reversedColor = line.foregroundColor
                if isExpanded {
                        VStack(alignment: .leading) {
                                Button {
                                        isExpanded.toggle()
                                } label: {
                                        HStack {
                                                HStack(spacing: 6) {
                                                        ZStack {
                                                                indicatingColor.clipShape(.circle)
                                                                Text(verbatim: line.indicator)
                                                                        .font(.display)
                                                                        .lineLimit(1)
                                                                        .minimumScaleFactor(0.2)
                                                                        .foregroundStyle(reversedColor)
                                                                        .padding(3)
                                                        }
                                                        .frame(width: 30, height: 30)
                                                        Text(verbatim: line.tailLabel).font(.display)
                                                }
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
                                                MacMetroStationLabel(station: line.stations[index], line: line, indicatingColor: line.backgroundColor)
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
                                        HStack(spacing: 6) {
                                                ZStack {
                                                        indicatingColor.clipShape(.circle)
                                                        Text(verbatim: line.indicator)
                                                                .font(.display)
                                                                .lineLimit(1)
                                                                .minimumScaleFactor(0.2)
                                                                .foregroundStyle(reversedColor)
                                                                .padding(3)
                                                }
                                                .frame(width: 30, height: 30)
                                                Text(verbatim: line.tailLabel).font(.display)
                                        }
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

#endif
