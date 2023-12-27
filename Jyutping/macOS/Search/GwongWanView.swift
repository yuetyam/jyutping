#if os(macOS)

import SwiftUI
import AppDataSource

struct GwongWanView: View {
        let entry: GwongWanCharacter
        var body: some View {
                VStack(alignment: .leading, spacing: 10) {
                        HStack {
                                Text(verbatim: "讀音")
                                Text.separator
                                HStack(spacing: 32) {
                                        Text(verbatim: entry.faancitText)
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
