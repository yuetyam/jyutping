#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct FanWanCuetYiuView: View {
        let entry: FanWanCuetYiu
        var body: some View {
                let homophoneText = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
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
                                Text(verbatim: entry.ipa).font(.title3).foregroundStyle(Color.secondary)
                                Spacer()
                                Speaker(entry.jyutping).opacity(entry.romanization.isValidJyutping ? 1 : 0)
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
