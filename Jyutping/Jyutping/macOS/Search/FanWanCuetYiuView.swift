#if os(macOS)

import SwiftUI
import Materials

struct FanWanCuetYiuView: View {
        let entry: FanWanCuetYiu
        var body: some View {
                VStack(alignment: .leading) {
                        HStack {
                                Text(verbatim: "讀音")
                                Text.separator
                                Text(verbatim: entry.abstract)
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "轉寫")
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.title3.monospaced())
                                }
                                Text(verbatim: entry.ipa).font(.title3).foregroundColor(.secondary)
                                Spacer()
                                Speaker(entry.jyutping).opacity(entry.romanization.isValidJyutping ? 1 : 0)
                        }
                        HStack {
                                Text(verbatim: "釋義")
                                Text.separator
                                Text(verbatim: entry.interpretation)
                        }
                }
        }
}

#endif
