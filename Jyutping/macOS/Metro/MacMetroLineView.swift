#if os(macOS)

import SwiftUI
import AppDataSource

struct MacMetroLineView: View {

        let line: Metro.Line
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
                                .padding(.vertical)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        isExpanded.toggle()
                                }
                                VStack(alignment: .leading) {
                                        ForEach(0..<line.stations.count, id: \.self) { index in
                                                MacMetroStationLabel(station: line.stations[index])
                                        }
                                }
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                        .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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

#endif
