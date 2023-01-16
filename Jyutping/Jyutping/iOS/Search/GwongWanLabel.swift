#if os(iOS)

import SwiftUI
import Materials

struct GwongWanLabel: View {
        let entry: GwongWan
        var body: some View {
                VStack(alignment: .leading, spacing: 8) {
                        HStack {
                                Text(verbatim: "讀音")
                                Text.separator
                                HStack(spacing: 16) {
                                        Text(verbatim: "\(entry.faancit)切")
                                        Text(verbatim: entry.hierarchy).minimumScaleFactor(0.2).lineLimit(1)
                                }
                        }
                        HStack {
                                Text(verbatim: "釋義")
                                Text.separator
                                Text(verbatim: entry.interpretation)
                        }
                }
                .font(.copilot)
        }
}

#endif
