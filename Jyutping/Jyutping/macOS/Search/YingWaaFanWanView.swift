#if os(macOS)

import SwiftUI
import Materials

struct YingWaaFanWanView: View {
        let entry: YingWaaFanWan
        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "原文")
                                        Text.separator
                                        Text(verbatim: entry.pronunciation).font(.title3)
                                }
                                if let pronunciationMark = entry.pronunciationMark {
                                        Text(verbatim: pronunciationMark).font(.body.italic())
                                }
                                if let interpretation = entry.interpretation {
                                        Text(verbatim: interpretation).font(.body)
                                }
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "轉寫")
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.title3.monospaced())
                                }
                                Text(verbatim: entry.ipa).font(.title3).foregroundColor(.secondary)
                                Spacer()
                                Speaker(entry.jyutping)
                        }
                }
        }
}

#endif
