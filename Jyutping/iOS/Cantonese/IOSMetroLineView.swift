#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSMetroLineView: View {

        let line: Metro.Line
        @Binding var isExpanded: Bool

        var body: some View {
                Button {
                        isExpanded.toggle()
                } label: {
                        HStack {
                                Text(verbatim: line.name)
                                Spacer()
                                Image(systemName: isExpanded ? "chevron.down" : "chevron.backward")
                        }
                        .textSelection(.disabled)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if isExpanded {
                        ForEach(line.stations.indices, id: \.self) { index in
                                IOSMetroStationLabel(station: line.stations[index])
                        }
                }
        }
}

#endif
