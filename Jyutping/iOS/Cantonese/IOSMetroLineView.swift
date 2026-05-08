#if os(iOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct IOSMetroLineView: View {

        let line: Metro.Line
        @Binding var isExpanded: Bool

        var body: some View {
                let indicatingColor = line.backgroundColor
                let reversedColor = line.foregroundColor
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
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if isExpanded {
                        ForEach(line.stations.indices, id: \.self) { index in
                                IOSMetroStationLabel(station: line.stations[index], line: line, indicatingColor: indicatingColor)
                        }
                }
        }
}

#endif
