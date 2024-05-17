#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct FanWanCuetYiuLabel: View {
        let entry: FanWanCuetYiu
        var body: some View {
                let homophoneText = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                VStack(alignment: .leading) {
                        HStack {
                                Text(verbatim: "讀音")
                                Text.separator
                                Text(verbatim: entry.abstract).font(.body).minimumScaleFactor(0.5).lineLimit(1)
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "轉寫")
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.fixedWidth)
                                }
                                Text(verbatim: entry.ipa).font(.body).foregroundStyle(Color.secondary)
                                Spacer()
                                Speaker(entry.jyutping).opacity(entry.romanization.isValidJyutping ? 1 : 0)
                        }
                        HStack {
                                Text(verbatim: "釋義")
                                Text.separator
                                Text(verbatim: entry.interpretation).font(.body)
                        }
                        if let homophoneText {
                                HStack {
                                        Text(verbatim: "同音")
                                        Text.separator
                                        Text(verbatim: homophoneText).font(.body)
                                }
                                .padding(.top, 4)
                        }
                }
                .font(.copilot)
        }
}

#endif
