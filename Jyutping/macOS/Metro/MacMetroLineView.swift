#if os(macOS)

import SwiftUI
import AppDataSource

struct MacMetroLineView: View {

        let line: Metro.Line
        @Binding var isExpanded: Bool

        var body: some View {
                if isExpanded {
                        VStack(alignment: .leading) {
                                Button {
                                        isExpanded.toggle()
                                } label: {
                                        HStack {
                                                Text(verbatim: line.name)
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
                                                MacMetroStationLabel(station: line.stations[index])
                                        }
                                }
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 12)
                        .stack()
                } else {
                        Button {
                                isExpanded.toggle()
                        } label: {
                                HStack {
                                        Text(verbatim: line.name)
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
