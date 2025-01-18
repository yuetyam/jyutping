#if os(iOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct IOSHundredFamilySurnamesView: View {

        @State private var surnames: [TextRomanization] = AppMaster.surnames
        @State private var isSurnamesLoaded: Bool = false

        var body: some View {
                List {
                        Section {
                                TermView(term: Term(name: "百家姓", romanization: "baak3 gaa1 sing3"))
                        }
                        ForEach(surnames.indices, id: \.self) { index in
                                Section {
                                        IOSTextRomanizationLabel(item: surnames[index])
                                }
                        }
                }
                .task {
                        guard isSurnamesLoaded.negative else { return }
                        defer { isSurnamesLoaded = true }
                        if AppMaster.surnames.isEmpty {
                                AppMaster.fetchSurnames()
                                surnames = HundredFamilySurnames.fetch()
                        } else {
                                surnames = AppMaster.surnames
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSCantoneseTab.NavigationTitle.HundredFamilySurnames")
                .navigationBarTitleDisplayMode(.inline)
        }
}

struct IOSTextRomanizationLabel: View {
        let item: TextRomanization
        var body: some View {
                let texts = item.text.dropLast().split(separator: "，").map({ String($0) })
                let romanizations = item.romanization.dropLast().split(separator: "，").map({ String($0) })
                ForEach(texts.indices, id: \.self) { index in
                        let text = texts[index]
                        let romanization = romanizations[index]
                        HStack(spacing: 18) {
                                TextRomanizationView(text: text, romanization: romanization)
                                Speaker(romanization)
                        }
                }
        }
}

#endif
