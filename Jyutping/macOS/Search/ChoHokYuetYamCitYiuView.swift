#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct ChoHokYuetYamCitYiuView: View {
        let entry: ChoHokYuetYamCitYiu
        var body: some View {
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
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
                                Text(verbatim: ipaText).font(.title3).foregroundStyle(Color.secondary)
                                Spacer()
                                Speaker(entry.romanization).opacity(entry.romanization.isValidJyutping ? 1 : 0)
                        }
                        if let homophoneText {
                                HStack {
                                        Text(verbatim: "同音")
                                        Text.separator
                                        Text(verbatim: homophoneText)
                                }
                        }
                }
        }
}

#endif
