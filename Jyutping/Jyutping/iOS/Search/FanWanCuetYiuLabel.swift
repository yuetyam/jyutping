#if os(iOS)

import SwiftUI
import Materials

struct FanWanCuetYiuLabel: View {
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
                                        Text(verbatim: entry.romanization).font(.fixedWidth)
                                }
                                Text(verbatim: entry.ipa).font(.body).foregroundColor(.secondary)
                                Spacer()
                                Speaker(entry.jyutping)
                        }
                        HStack {
                                Text(verbatim: "釋義")
                                Text.separator
                                Text(verbatim: entry.interpretation)
                        }
                }
                .font(.copilot)
        }
}

#endif
