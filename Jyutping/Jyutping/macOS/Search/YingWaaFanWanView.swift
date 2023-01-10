#if os(macOS)

import SwiftUI
import Materials

struct YingWaaFanWanView: View {
        let entry: YingWaaFanWan
        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "書本原文標示")
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.title3)
                                }
                                if let romanizationType = entry.romanizationType {
                                        Text(verbatim: romanizationType)
                                }
                                if let romanizationNote = entry.romanizationNote {
                                        Text(verbatim: romanizationNote)
                                }
                                if let interpretation = entry.interpretation {
                                        Text(verbatim: interpretation)
                                }
                                if let note = entry.note {
                                        Text(verbatim: note)
                                }
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "對應現代粵拼")
                                        Text.separator
                                        Text(verbatim: entry.jyutping).font(.title3.monospaced())
                                }
                                Text(verbatim: Syllable2IPA.IPAText(entry.jyutping)).font(.title3).foregroundColor(.secondary)
                                if let note = entry.note {
                                        Text(verbatim: note)
                                }
                                Spacer()
                                Speaker(entry.jyutping)
                        }
                }
        }
}

#endif
