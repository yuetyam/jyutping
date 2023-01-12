#if os(iOS)

import SwiftUI
import Materials

struct ChoHokYuetYamCitYiuLabel: View {
        let entry: ChoHokYuetYamCitYiu
        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "原文")
                                        Text.separator
                                        Text(verbatim: entry.pronunciation).font(.body)
                                }
                                Text(verbatim: entry.tone)
                                Text(verbatim: entry.faancit)
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
