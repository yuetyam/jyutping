#if os(macOS)

import SwiftUI
import Materials

struct ChoHokYuetYamCitYiuView: View {
        let entry: ChoHokYuetYamCitYiu
        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "原文")
                                        Text.separator
                                        Text(verbatim: entry.pronunciation).font(.title3)
                                }
                                Text(verbatim: entry.tone)
                                Text(verbatim: entry.faancit)
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
