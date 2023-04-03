#if os(iOS)

import SwiftUI
import Materials

struct IOSHansMessView: View {

        @State private var items: [HansMess] = []
        @State private var isDataSourceLoaded: Bool = false

        var body: some View {
                List {
                        ForEach(0..<items.count, id: \.self) { index in
                                Section {
                                        if index == 0 {
                                                HStack {
                                                        Text(verbatim: "簡化字").frame(width: 50)
                                                        Text(verbatim: "傳統漢字").frame(width: 100, alignment: .leading)
                                                        Text(verbatim: "備註")
                                                }
                                                .font(.footnote)
                                        }
                                        MessLabel(item: items[index])
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                }
                .textSelection(.enabled)
                .task {
                        guard !isDataSourceLoaded else { return }
                        items = HansMess.fetch()
                        isDataSourceLoaded = true
                }
                .navigationTitle("Hans Mess")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private struct MessLabel: View {
        let item: HansMess
        var body: some View {
                HStack {
                        Text(verbatim: item.simplified).frame(width: 50)
                        VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                        Text(verbatim: item.traditional.text)
                                                .minimumScaleFactor(0.4)
                                                .lineLimit(1)
                                                .frame(width: 100, alignment: .leading)
                                        Text(verbatim: item.traditional.note)
                                                .minimumScaleFactor(0.4)
                                                .lineLimit(1)
                                }
                                Divider()
                                HStack {
                                        Text(verbatim: item.altTraditional.text)
                                                .minimumScaleFactor(0.4)
                                                .lineLimit(1)
                                                .frame(width: 100, alignment: .leading)
                                        Text(verbatim: item.altTraditional.note)
                                                .minimumScaleFactor(0.4)
                                                .lineLimit(1)
                                }
                        }
                }
        }
}

#endif
