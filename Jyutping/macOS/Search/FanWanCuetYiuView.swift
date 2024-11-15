#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct FanWanCuetYiuView: View {
        let entry: FanWanCuetYiu
        var body: some View {
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
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
                                Text(verbatim: ipaText).font(.title3).opacity(0.66)
                                Spacer()
                                Speaker(entry.romanization).opacity(entry.romanization.isValidJyutpingSyllable ? 1 : 0)
                        }
                        if let homophoneText {
                                HStack {
                                        Text(verbatim: "同音")
                                        Text.separator
                                        Text(verbatim: homophoneText)
                                }
                                .padding(.bottom, 1)
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
