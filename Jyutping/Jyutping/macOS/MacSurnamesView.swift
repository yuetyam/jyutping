#if os(macOS)

import SwiftUI
import Materials

struct MacSurnamesView: View {

        @State private var surnames: [BaakGaaSing.SurnameUnit] = []
        @State private var isSurnamesLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                HeaderTermView(term: Term(name: "百家姓", romanization: "baak3 gaa1 sing3")).block()
                                ForEach(0..<surnames.count, id: \.self) { index in
                                        MacSurnameUnitView(item: surnames[index])
                                }
                        }
                        .padding()
                }
                .task {
                        guard !isSurnamesLoaded else { return }
                        surnames = BaakGaaSing.fetch()
                        isSurnamesLoaded = true
                }
                .navigationTitle("Surnames")
        }
}

private struct MacSurnameUnitView: View {

        let item: BaakGaaSing.SurnameUnit

        var body: some View {
                HStack(spacing: 22) {
                        HStack {
                                Speaker(item.text)
                                Text(verbatim: item.text).font(.master)
                        }
                        HStack {
                                Speaker(item.romanization)
                                Text(verbatim: item.romanization)
                        }
                        Spacer()
                }
                .textSelection(.enabled)
                .block()
        }
}

#endif
