#if os(iOS)

import SwiftUI
import Materials

struct IOSSurnamesView: View {

        @State private var surnames: [BaakGaaSing.SurnameUnit] = []
        @State private var isSurnamesLoaded: Bool = false

        var body: some View {
                List {
                        Section {
                                HeaderTermView(term: Term(name: "百家姓", romanization: "baak3 gaa1 sing3"))
                        }
                        ForEach(0..<surnames.count, id: \.self) { index in
                                Section {
                                        IOSSurnameUnitView(item: surnames[index])
                                }
                        }
                }
                .task {
                        guard !isSurnamesLoaded else { return }
                        surnames = BaakGaaSing.fetch()
                        isSurnamesLoaded = true
                }
                .textSelection(.enabled)
                .navigationTitle("Surnames")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private struct IOSSurnameUnitView: View {

        let item: BaakGaaSing.SurnameUnit

        var body: some View {
                VStack {
                        HStack {
                                Text(verbatim: item.text)
                                        .tracking(8)
                                        .font(.title3)
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                                Spacer()
                                Speaker(item.text)
                        }
                        Divider()
                        HStack {
                                Text(verbatim: item.romanization)
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                                Spacer()
                                Speaker(item.romanization)
                        }
                }
        }
}

#endif
