#if os(macOS)

import SwiftUI
import Materials

struct MacHansMessView: View {

        @State private var items: [HansMess] = []
        @State private var isDataSourceLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                                HStack {
                                        Text(verbatim: "簡化字").frame(width: 64)
                                        Text(verbatim: "傳統漢字").frame(width: 100, alignment: .leading)
                                        Text(verbatim: "備註")
                                        Spacer()
                                }
                                .font(.copilot)
                                .textSelection(.enabled)
                                ForEach(0..<items.count, id: \.self) { index in
                                        MessView(item: items[index])
                                }
                        }
                        .padding()
                }
                .task {
                        guard !isDataSourceLoaded else { return }
                        items = HansMess.fetch()
                        isDataSourceLoaded = true
                }
                .navigationTitle("Hans Mess")
        }
}

private struct MessView: View {
        let item: HansMess
        var body: some View {
                HStack {
                        Text(verbatim: item.simplified).frame(width: 64)
                        VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                        Text(verbatim: item.traditional.text)
                                                .minimumScaleFactor(0.4)
                                                .lineLimit(1)
                                                .frame(width: 100, alignment: .leading)
                                        Text(verbatim: item.traditional.note)
                                                .minimumScaleFactor(0.4)
                                                .lineLimit(1)
                                                .frame(width: 174, alignment: .leading)
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
                                                .frame(width: 174, alignment: .leading)
                                }
                        }
                        .fixedSize()
                        Spacer()
                }
                .font(.master)
                .textSelection(.enabled)
                .padding(.vertical, 12)
                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

#endif
