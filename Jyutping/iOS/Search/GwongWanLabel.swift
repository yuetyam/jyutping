#if os(iOS)

import SwiftUI
import AppDataSource

struct GwongWanLabel: View {
        let entry: GwongWanCharacter
        var body: some View {
                VStack(alignment: .leading, spacing: 8) {
                        HStack {
                                Text(verbatim: "讀音")
                                Text.separator
                                HStack(spacing: 16) {
                                        Text(verbatim: entry.faancitText).font(.body)
                                        Text(verbatim: entry.hierarchy).font(.body).minimumScaleFactor(0.5).lineLimit(1)
                                }
                        }
                        HStack {
                                Text(verbatim: "釋義")
                                Text.separator
                                Text(verbatim: entry.interpretation).font(.body)
                        }
                }
                .font(.copilot)
        }
}

#endif
