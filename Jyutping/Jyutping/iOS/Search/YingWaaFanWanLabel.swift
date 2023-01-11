#if os(iOS)

import SwiftUI
import Materials

struct YingWaaFanWanLabel: View {
        let entry: YingWaaFanWan
        var body: some View {
                VStack(alignment: .leading) {
                        HStack {
                                Text(verbatim: "原文")
                                Text.separator
                                Text(verbatim: entry.pronunciation)
                                if let pronunciationType = entry.pronunciationType {
                                        Text(verbatim: pronunciationType)
                                }
                                if let interpretation = entry.interpretation {
                                        Text(verbatim: interpretation)
                                }
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "轉寫")
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.body)
                                }
                                Text(verbatim: entry.ipa).font(.body).foregroundColor(.secondary)
                                Spacer()
                                Speaker(entry.jyutping)
                        }
                }
                .font(.copilot)
        }
}

#endif
