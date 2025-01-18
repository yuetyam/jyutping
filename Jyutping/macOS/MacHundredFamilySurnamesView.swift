#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacHundredFamilySurnamesView: View {

        @State private var surnames: [TextRomanization] = AppMaster.surnames
        @State private var isSurnamesLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                TermView(term: Term(name: "百家姓", romanization: "baak3 gaa1 sing3")).block()
                                ForEach(surnames.indices, id: \.self) { index in
                                        MacTextRomanizationLabel(item: surnames[index])
                                }
                        }
                        .padding()
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
                .animation(.default, value: surnames.count)
                .navigationTitle("MacSidebar.NavigationTitle.HundredFamilySurnames")
        }
}

struct MacTextRomanizationLabel: View {
        let item: TextRomanization
        var body: some View {
                let texts = item.text.dropLast().split(separator: "，").map({ String($0) })
                let romanizations = item.romanization.dropLast().split(separator: "，").map({ String($0) })
                VStack(alignment: .leading, spacing: 12) {
                        ForEach(texts.indices, id: \.self) { index in
                                let text = texts[index]
                                let romanization = romanizations[index]
                                HStack(alignment: .bottom, spacing: 18) {
                                        TextRomanizationView(text: text, romanization: romanization)
                                        Speaker(romanization)
                                        Spacer()
                                }
                        }
                }
                .block()
        }
}

#endif
