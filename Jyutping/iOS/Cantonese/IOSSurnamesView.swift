#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSSurnamesView: View {

        @State private var surnames: [LineUnit] = AppMaster.surnames
        @State private var isSurnamesLoaded: Bool = false

        var body: some View {
                List {
                        Section {
                                TermView(term: Term(name: "百家姓", romanization: "baak3 gaa1 sing3"))
                        }
                        ForEach(0..<surnames.count, id: \.self) { index in
                                Section {
                                        IOSLineUnitView(line: surnames[index])
                                }
                        }
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
                .textSelection(.enabled)
                .navigationTitle("title.surnames")
                .navigationBarTitleDisplayMode(.inline)
        }
}

struct IOSLineUnitView: View {

        let line: LineUnit

        var body: some View {
                VStack {
                        HStack {
                                Text(verbatim: line.text)
                                        .tracking(8)
                                        .font(.title3)
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                                Spacer()
                                Speaker {
                                        Speech.speak(line.text, isRomanization: false)
                                }
                        }
                        Divider()
                        HStack {
                                Text(verbatim: line.romanization)
                                        .minimumScaleFactor(0.4)
                                        .lineLimit(1)
                                Spacer()
                                Speaker(line.romanization)
                        }
                }
        }
}

#endif
