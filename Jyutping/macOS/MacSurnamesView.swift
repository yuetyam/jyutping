#if os(macOS)

import SwiftUI
import AppDataSource

struct MacSurnamesView: View {

        @State private var surnames: [LineUnit] = AppMaster.surnames
        @State private var isSurnamesLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                TermView(term: Term(name: "百家姓", romanization: "baak3 gaa1 sing3")).block()
                                ForEach(0..<surnames.count, id: \.self) { index in
                                        MacLineUnitView(line: surnames[index])
                                }
                        }
                        .padding()
                }
                .task {
                        guard !isSurnamesLoaded else { return }
                        defer { isSurnamesLoaded = true }
                        if AppMaster.surnames.isEmpty {
                                AppMaster.fetchSurnames()
                                surnames = BaakGaaSing.fetch()
                        } else {
                                surnames = AppMaster.surnames
                        }
                }
                .animation(.default, value: surnames.count)
                .navigationTitle("Hundred Family Surnames")
        }
}

struct MacLineUnitView: View {

        let line: LineUnit

        var body: some View {
                HStack(spacing: 24) {
                        HStack {
                                Speaker(line.text)
                                Text(verbatim: line.text).font(.master)
                        }
                        HStack {
                                Speaker(line.romanization)
                                Text(verbatim: line.romanization).font(.body.monospaced())
                        }
                        Spacer()
                }
                .textSelection(.enabled)
                .block()
        }
}

#endif
