#if os(iOS)

import SwiftUI
import Materials

struct YingWaaFanWanLabel: View {
        let entry: YingWaaFanWan
        var body: some View {
                VStack(alignment: .leading) {
                        HStack {
                                Text(verbatim: "書本原文：")
                                Text(verbatim: entry.romanization).font(.body)
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
                        HStack {
                                Text(verbatim: "對應粵拼：")
                                Text(verbatim: entry.jyutping).font(.body)
                                Text(verbatim: Syllable2IPA.IPAText(entry.jyutping)).font(.body).foregroundColor(.secondary)
                                if let note = entry.note {
                                        Text(verbatim: note)
                                }
                                Spacer()
                                Speaker(entry.jyutping)
                        }
                }
                .font(.copilot)
        }
}

#endif
