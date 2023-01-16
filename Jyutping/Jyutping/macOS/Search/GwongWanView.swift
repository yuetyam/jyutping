#if os(macOS)

import SwiftUI
import Materials

struct GwongWanView: View {
        let entry: GwongWan
        var body: some View {
                VStack(alignment: .leading, spacing: 10) {
                        HStack {
                                Text(verbatim: "讀音")
                                Text.separator
                                HStack(spacing: 32) {
                                        Text(verbatim: "\(entry.faancit)切")
                                        Text(verbatim: entry.hierarchy)
                                }
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "釋義")
                                Text.separator
                                Text(verbatim: entry.interpretation)
                                Spacer()
                        }
                }
        }
}

#endif
